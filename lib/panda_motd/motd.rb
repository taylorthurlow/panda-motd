require 'sysinfo'

class MOTD
  attr_reader :components

  def initialize
    @components = [
      AsciiTextArt.new(SysInfo.new.hostname, 'slant'),
      Uptime.new,
      ServiceStatus.new(
        chunkwm: 'chunkwm',
        skhd: 'skhd',
        'elasticsearch@5.6': 'elasticsearch'
      ).parse_services
    ]
  end

  def to_s
    return @components.map(&:to_s).join("\n\n")
  end
end
