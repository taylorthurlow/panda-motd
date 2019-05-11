# frozen_string_literal: true

require "date"

class LastLogin < Component
  def initialize(motd)
    super(motd, "last_login")
  end

  def process
    @users = @config["users"]
    @results = parse_last_logins(@users)
  end

  def to_s
    <<~HEREDOC
      Last Login:
      #{@results.map { |u, l| parse_result(u, l) }.join("\n")}
    HEREDOC
  end

  private

  def parse_result(user, logins)
    logins_part = if logins.empty?
                    "    no logins found for user."
                  else
                    longest_size = logins.map { |l| l[:location].length }.max
                    logins.map { |l| parse_login(l, longest_size) }.join("\n")
                  end
    <<~HEREDOC
        #{user}:
      #{logins_part}
    HEREDOC
  end

  def parse_login(login, longest_size)
    location = login[:location].ljust(longest_size, " ")
    start = login[:time_start].strftime("%m/%d/%Y %I:%M%p")
    finish = if login[:time_end].is_a? String # not a date
               if login[:time_end] == "still logged in"
                 login[:time_end].green
               else
                 login[:time_end].yellow
               end
             else
               "#{((login[:time_end] - login[:time_start]) / 60).to_i} minutes"
             end
    "    from #{location} at #{start} (#{finish})"
  end

  def parse_last_logins(users)
    users.map do |(username, num_logins)|
      cmd_result = `last --time-format=iso #{username}`
      logins = cmd_result.lines
                         .select { |entry| entry.start_with?(username) }
                         .take(num_logins)

      [username.to_sym, logins.map! { |l| hashify_login(l, username) }]
    end.to_h
  end

  def hashify_login(login, username)
    re = login.chomp.split(/(?:\s{2,})|(?<=\d)(?:\s-\s)/)
    date = re[4].scan(/\d{4}-\d{2}-[\dT:]+-\d{4}/)

    time_end = date.any? ? Time.parse(re[4]) : re[4]

    {
      username: username,
      location: re[2],
      time_start: Time.parse(re[3]),
      time_end: time_end,
    }
  end
end
