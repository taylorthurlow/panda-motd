require 'sysinfo'

class MOTD
  attr_reader :config, :components

  def initialize
    @config = Config.new

    @components = []
    @config.components_enabled.each do |component_class|
      @components << component_class.new(self)
    end

    @components.each(&:process)
  end

  def to_s
    return @components.map(&:to_s).join("\n\n")
  end
end
