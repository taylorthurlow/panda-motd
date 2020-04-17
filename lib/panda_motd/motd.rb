# typed: false
# frozen_string_literal: true

require "sysinfo"

class MOTD
  attr_reader :config, :components

  # Creates an MOTD by parsing the provided config file, and processing each
  # component.
  #
  # @param config_path [String] The path to the configuration file. If not
  #   provided, the default config path will be used.
  # @param process [Boolean] whether or not to actually process and evaluate
  #   the printable results of each component
  def initialize(config_path = nil, process = true)
    @config = Config.new(config_path)
    @components = @config.components_enabled.map { |ce| ce.new(self) }
    @components.each(&:process) if process
  end

  # Takes each component on the MOTD and joins them together in a printable
  # format. It inserts two newlines in between each component, ensuring that
  # there is one empty line between each. If a component has any errors, the
  # error will be printed in a clean way.
  def to_s
    @components.map do |c|
      if c.errors.any?
        c.errors.map(&:to_s).join("\n")
      else
        c.to_s
      end
    end.join("\n\n")
  end
end
