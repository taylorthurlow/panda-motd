require 'colorize'

class ServiceStatus
  attr_reader :results

  def initialize(motd)
    @motd = motd
    @config = motd.config.component_config('service_status')
  end

  def process
    @services = @config['services']
    @results = {}

    parse_services
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

  def parse_services
    case Gem::Platform.local.os
    when 'darwin'
      @results = parse_services_macos(@services)
    when 'linux'
      @results = parse_services_linux(@services)
    end
  end

  def parse_services_macos(services)
    results = {}

    # valid statuses are started, stopped, error, and unknown
    `brew services list`.split("\n").each do |line|
      parsed_name = line.split[0]
      parsed_status = line.split[1]

      matching_service = services.find { |service, _name| service == parsed_name }

      if matching_service
        results[parsed_name.to_sym] = parsed_status.send(macos_service_colors[parsed_status.to_sym])
      end
    end

    return results
  end

  def parse_services_linux(services)
    results = {}

    `systemctl | grep '\.service'`.split("\n").each do |line|
      parsed_name = line.split[0].gsub('.service', '')
      parsed_status = line.split[3]

      matching_service = services.find { |service, _name| service == parsed_name }

      if matching_service
        results[parsed_name.to_sym] = parsed_status.send(linux_service_colors[parsed_status.to_sym])
      end
    end

    return results
  end

  def macos_service_colors
    return {
      started: :green,
      stopped: :white,
      error: :red,
      unknown: :yellow
    }
  end

  def linux_service_colors
    return {
      running: :green,
      exited: :white,
      failed: :red
    }
  end
end
