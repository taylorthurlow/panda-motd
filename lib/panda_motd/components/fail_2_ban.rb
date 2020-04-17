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

      return { total: 0, current: 0 }
    else
      total_matcher = cmd_result.match(/Total banned:\s+([0-9]+)/)
      if total_matcher && total_matcher[1]
        total = T.cast(total_matcher[1].to_i, Integer)
      else
        raise "Unable to determine number of total bans for jail: #{jail}"
      end

      current_matcher = cmd_result.match(/Currently banned:\s+([0-9]+)/)
      if current_matcher && current_matcher[1]
        current = T.cast(current_matcher[1].to_i, Integer)
      else
        raise "Unable to determine number of current bans for jail: #{jail}"
      end
    end

    { total: T.must(total), current: T.must(current) }
  end
end
