require 'colorize'

class ServiceStatus
  attr_reader :name, :errors
  attr_reader :results

  def initialize(motd)
    @name = 'service_status'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    @services = @config['services']
    @results = parse_services(@services)
  end

  def to_s
    if @results.any?
      result = "Services:\n"
      longest_name_size = @results.keys.map { |k| k.to_s.length }.max + 1 # add 1 for the ':' at the end
      @results.each_with_index do |(name, status), i|
        name_part = (name.to_s + ':').ljust(longest_name_size, ' ')
        status_part = status.to_s.send(service_colors[status])
        result += "  #{name_part} #{status_part}"
        result += "\n" unless i == @results.count - 1 # don't print newline for last entry
      end

      return result
    else
      return "Services:\n  No matching services found."
    end
  end

  private

  def parse_services(services)
    results = {}

    cmd_result = `systemctl | grep '\.service'`.delete("^\u{0000}-\u{007F}")

    if cmd_result.empty?
      @errors << ComponentError.new(self, 'Unable to parse systemctl output')
    end

    cmd_result.split("\n").each do |line|
      parsed_name = line.split[0].gsub('.service', '')
      parsed_status = line.split[3]

      matching_service = services.find { |service, _name| service == parsed_name }

      if matching_service
        results[parsed_name.to_sym] = parsed_status.to_sym
      end
    end

    return results
  end

  def service_colors
    return {
      running: :green,
      exited: :white,
      failed: :red
    }
  end
end
