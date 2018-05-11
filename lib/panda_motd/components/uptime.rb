require 'sysinfo'

class Uptime
  attr_reader :name, :errors
  attr_reader :days, :hours, :minutes

  def initialize(motd)
    @name = 'uptime'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    sysinfo = SysInfo.new
    uptime = sysinfo.uptime

    @days = (uptime / 24).floor
    @hours = (uptime - @days * 24).floor
    @minutes = ((uptime - @days * 24 - hours) * 60).floor
  end

  def to_s
    result = ''
    result += "#{@days} day#{'s' if @days != 1}, " unless @days.zero?
    result += "#{@hours} hour#{'s' if @hours != 1}, " unless @hours.zero? && @days.zero?
    result += "#{@minutes} minute#{'s' if @minutes != 1}"
    return "#{@config['prefix'] || 'up'} #{result}"
  end
end
