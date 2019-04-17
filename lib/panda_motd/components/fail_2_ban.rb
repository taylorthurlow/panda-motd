class Fail2Ban < Component
  def initialize(motd)
    super(motd, 'fail_2_ban')
  end

  def process
    @results = {}
    parse_log_info
  end

  def to_s
    result = "Fail2Ban:\n"
    @results.each do |name, stats|
      result += "  #{name}:\n"
      current_bans = stats[:total_bans] - stats[:total_unbans]
      result += "    Total bans:   #{stats[:total_bans]}\n"
      result += "    Current bans: #{current_bans}\n"
    end

    result.gsub(/\s$/, '')
  end

  private

  def parse_log_info
    log_path = @config['log_path'] || '/var/log'
    result1 = `cat #{log_path}/fail2ban*.log`
    result2 = `zcat #{log_path}/fail2ban*.gz`

    logs = (result1 + "\n" + result2).split("\n").reject(&:empty?)
    re = /([0-9]{4}-[0-9]{2}-[0-9]{2}).+\[(\w+)\].+(Ban|Unban) ([0-9\.]+)/

    logs.each { |l| parse_log_line(l, re) }
  end

  def parse_log_line(line, regexp)
    data = line.match(regexp)
    return unless data
    return if @config['exclude_jails']&.include? data[2]

    jail = data[2].to_sym
    initialize_results_jail(jail)

    metric = data[3] == 'Ban' ? :total_bans : :total_unbans
    @results[jail][metric] += 1
  end

  def initialize_results_jail(jail)
    return if @results[jail]

    @results[jail] = {
      total_bans: 0,
      total_unbans: 0
    }
  end
end
