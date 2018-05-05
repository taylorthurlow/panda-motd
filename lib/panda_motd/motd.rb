require 'sysinfo'

class MOTD
  attr_reader :components

  def initialize
    @components = [
      AsciiTextArt.new(SysInfo.new.hostname, 'slant'),
      Uptime.new
    ]
  end

  def to_s
    return @components.map(&:to_s).join("\n\n")
  end
end
