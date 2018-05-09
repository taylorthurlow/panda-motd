require 'sysinfo'

class MOTD
  attr_reader :config, :components

  def initialize
    @config = Config.new
    @components = @config.components_enabled.map { |ce| ce.new(self) }
    @components.each(&:process)
  end

  def to_s
    return @components.map(&:to_s).join("\n\n")
  end
end
