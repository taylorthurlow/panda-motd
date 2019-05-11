# frozen_string_literal: true

require "sysinfo"

class Uptime < Component
  attr_reader :days, :hours, :minutes

  def initialize(motd)
    super(motd, "uptime")
  end

  def process
    uptime = SysInfo.new.uptime

    @days = (uptime / 24).floor
    @hours = (uptime - @days * 24).floor
    @minutes = ((uptime - @days * 24 - hours) * 60).floor
  end

  def to_s
    "#{@config["prefix"] || "up"} #{format_uptime}"
  end

  private

  def format_uptime
    [@days, @hours, @minutes].zip(%w[day hour minute])
                             .reject { |n, _word| n.zero? }
                             .map { |n, word| "#{n} #{word}#{"s" if n != 1}" }
                             .join(", ")
  end
end
