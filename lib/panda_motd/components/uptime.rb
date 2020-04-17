# typed: true
# frozen_string_literal: true

require "sysinfo"

class Uptime < Component
  attr_reader :days, :hours, :minutes

  def initialize(motd)
    super(motd, "uptime")
  end

  # Calculates the number of days, hours, and minutes based on the current
  # uptime value.
  #
  # @see Component#process
  def process
    uptime = SysInfo.new.uptime

    @days = (uptime / 24).floor
    @hours = (uptime - @days * 24).floor
    @minutes = ((uptime - @days * 24 - hours) * 60).floor
  end

  # Gets a printable uptime string with a prefix. The prefix can be configured,
  # and defaults to "up".
  def to_s
    "#{@config["prefix"] || "up"} #{format_uptime}"
  end

  private

  # Formats the uptime values in such a way that it is easier to read. If any
  # of the measurements are zero, that part is omitted. Words are properly
  # pluralized.
  #
  # Examples:
  #
  # `3d 20h 55m` becomes `3 days, 20 hours, 55 minutes`
  #
  # `3d 0h 55m` becomes `3 days, 55 minutes`
  def format_uptime
    [@days, @hours, @minutes].zip(%w[day hour minute])
                             .reject { |n, _word| n.zero? }
                             .map { |n, word| "#{n} #{word}#{"s" if n != 1}" }
                             .join(", ")
  end
end
