# typed: false
# frozen_string_literal: true

require "colorize"

class ServiceStatus < Component
  def initialize(motd)
    super(motd, "service_status")
  end

  # @see Component#process
  def process
    @services = @config["services"]
    @results = parse_services(@services)
  end

  # Gets a printable string to be printed in the MOTD. If there are no services
  # found in the result, it prints a warning message.
  def to_s
    return "Services:\n  No matching services found." unless @results.any?

    longest_name_size = @results.keys.map { |k| k.to_s.length }.max
    result = <<~HEREDOC
      Services:
      #{@results.map do |(name, status)|
      spaces = (" " * (longest_name_size - name.to_s.length + 1))
      status_part = status.to_s.colorize(service_colors[status.to_sym])
      "  #{name}#{spaces}#{status_part}"
    end.join("\n")}
    HEREDOC

    result.gsub(/\s$/, "")
  end

  private

  # Runs a `systemd` command to determine the state of a service. If the state
  # of the service was unable to be determined, an error will be added to the
  # component.
  #
  # @param service [String] the name of the systemd service
  #
  # @return [String] the state of the systemd service
  def parse_service(service)
    cmd_result = `systemd is-active #{service[0]}`.strip
    if cmd_result.empty?
      @errors << ComponentError.new(self, "systemctl output was blank.")
    end
    cmd_result
  end

  # Takes a list of services from a configuration file, and turns them into a
  # hash with the service states as values.
  #
  # @param services [Array] a two-element array where the first element is the
  #   name of the systemd service, and the second is the pretty name that
  #   represents it.
  #
  # @return [Hash]
  #   * `key`: The symbolized name of the systemd service
  #   * `value`: The symbolized service state
  def parse_services(services)
    services.map { |s| [s[1].to_sym, parse_service(s).to_sym] }.to_h
  end

  # A hash of mappings between a service state and a color which represents it.
  # The hash has a default value of red in order to handle unexpected service
  # status strings returned by `systemctl`.
  def service_colors
    colors = Hash.new(:red)
    colors[:active] = :green
    colors[:inactive] = :yellow
    colors[:failed] = :red

    colors
  end
end
