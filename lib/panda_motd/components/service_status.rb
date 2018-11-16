require 'colorize'

class ServiceStatus < Component
  def initialize(motd)
    super(motd, 'service_status')
  end

  def process
    @services = @config['services']
    @results = parse_services(@services)
  end

  def to_s
    return "Services:\n  No matching services found." unless @results.any?

    longest_name_size = @results.keys.map { |k| k.to_s.length }.max
    result = <<~HEREDOC
      Services:
      #{@results.map do |(name, status)|
        spaces = (' ' * (longest_name_size - name.to_s.length + 1))
        status_part = status.to_s.colorize(service_colors[status.to_sym])
        "  #{name}#{spaces}#{status_part}"
      end.join("\n")}
    HEREDOC

    result.gsub(/\s$/, '')
  end

  private

  def parse_service(service)
    cmd_result = `systemctl is-active #{service[0]}`.strip
    unless valid_responses.include? cmd_result
      @errors << ComponentError.new(self, 'Unable to parse systemctl output')
    end
    cmd_result
  end

  def parse_services(services)
    services.map { |s| [s[1].to_sym, parse_service(s).to_sym] }.to_h
  end

  def service_colors
    {
      active: :green,
      inactive: :red
    }
  end

  def valid_responses
    ['active', 'inactive']
  end
end
