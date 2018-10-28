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
    return "Services:\n  No matching services found." unless @results.any?

    longest_name_size = @results.keys.map { |k| k.to_s.length }.max
    <<~HEREDOC
      Services:
      #{@results.map do |(name, status)|
        name_part = name.to_s.ljust(longest_name_size, ' ') + ':'
        status_part = status.to_s.colorize(service_colors[status])
        "  #{name_part} #{status_part}"
      end.join("\n")}
    HEREDOC
  end

  private

  def parse_service(service)
    columns = service.split
    [columns[0].gsub('.service', ''), columns[3]]
  end

  def parse_services(services)
    cmd_result = `systemctl | grep '\.service'`

    @errors << ComponentError.new(self, 'Unable to parse systemctl output') if cmd_result.empty?

    cmd_result.lines
              .map { |line| parse_service(line) }
              .select { |name, _status| services.key?(name) }
              .map { |service| service.map(&:to_sym) }
              .to_h
  end

  def service_colors
    return {
      running: :green,
      exited: :white,
      failed: :red,
      not_found: :yellow
    }
  end
end
