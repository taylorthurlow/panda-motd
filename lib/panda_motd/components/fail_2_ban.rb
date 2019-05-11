class Fail2Ban < Component
  def initialize(motd)
    super(motd, "fail_2_ban")
  end

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

  def to_s
    result = "Fail2Ban:\n"
    @results[:jails].each do |name, stats|
      result += "  #{name}:\n"
      result += "    Total bans:   #{stats[:total]}\n"
      result += "    Current bans: #{stats[:current]}\n"
    end

    result.gsub(/\s$/, "")
  end

  private

  def jail_status(jail)
    cmd_result = `fail2ban-client status #{jail}`
    if cmd_result =~ /Sorry but the jail '#{jail}' does not exist/
      @errors << ComponentError.new(self, "Invalid jail name '#{jail}'.")
    else
      total = cmd_result.match(/Total banned:\s+([0-9]+)/)[1].to_i
      current = cmd_result.match(/Currently banned:\s+([0-9]+)/)[1].to_i
    end

    { total: total, current: current }
  end
end
