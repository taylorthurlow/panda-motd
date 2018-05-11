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
        name_part = if name.to_s.length > longest_name_size
                      name.to_s.slice(1..longest_name_size)
                    else
                      (name.to_s + ':').ljust(longest_name_size, ' ')
                    end
        result += "  #{name_part} #{status}"
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

    `systemctl | grep '\.service'`.split("\n").each do |line|
      parsed_name = line.split[0].gsub('.service', '')
      parsed_status = line.split[3]

      matching_service = services.find { |service, _name| service == parsed_name }

      if matching_service
        results[parsed_name.to_sym] = parsed_status.send(service_colors[parsed_status.to_sym])
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
