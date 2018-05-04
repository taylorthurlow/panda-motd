class MOTD
  attr_reader :components

  def initialize
    @components = [
      Uptime.new
    ]
  end

  def to_s
    return @components.map(&:to_s).join("\n")
  end
end
