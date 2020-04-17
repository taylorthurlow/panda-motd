# typed: false
# frozen_string_literal: true

class Fail2Ban < Component
  sig { params(motd: MOTD).void }

  def initialize(motd)
    super(motd, "fail_2_ban")
  end

  sig { void }

  def process
    @results = {
      jails: {},
    }

    @config["jails"].each do |jail|
      status = jail_status(jail)
      @results[:jails][jail] = {
        total: status[:total],
        current: status[:current],
      }
    end
  end

  sig { returns(String) }

  def to_s
    result = +"Fail2Ban:\n"
    @results[:jails].each do |name, stats|
      result << "  #{name}:\n"
      result << "    Total bans:   #{stats[:total]}\n"
      result << "    Current bans: #{stats[:current]}\n"
    end

    result.gsub!(/\s$/, "") || ""
  end

  private

  sig { params(jail: String).returns(T::Hash[Symbol, Integer]) }

  def jail_status(jail)
    cmd_result = `fail2ban-client status #{jail}`
    if cmd_result =~ /Sorry but the jail '#{jail}' does not exist/
      @errors << ComponentError.new(self, "Invalid jail name '#{jail}'.")
    else
      total_matcher = cmd_result.match(/Total banned:\s+([0-9]+)/)
      total = if total_matcher
          total_matcher[1].to_i
        else
          raise "Unable to determine number of total bans for jail: #{jail}"
        end

      current_matcher = cmd_result.match(/Currently banned:\s+([0-9]+)/)
      current = if current_matcher
          current_matcher[1].to_i
        else
          raise "Unable to determine number of current bans for jail: #{jail}"
        end
    end

    { total: total, current: current }
  end
end
