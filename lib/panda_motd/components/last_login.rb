require 'date'

class LastLogin < Component
  def initialize(motd)
    super(motd, 'last_login')
  end

  def process
    @users = @config['users']
    @results = parse_last_logins(@users)
  end

  def to_s
    <<~LAST
      Last Login:
      #{@results.map do |user, logins|
        logins_part =
          if logins.empty?
            '    no logins found for user.'
          else
            longest_location_size = logins.map { |l| l[:location].length }.max
            logins.map do |login|
              location_part = login[:location].ljust(longest_location_size, ' ')
              start_part = login[:time_start].strftime('%m/%d/%Y %I:%M%p')
              end_part = if login[:time_end].is_a? String # still logged in text
                           login[:time_end].green
                         else
                           "#{((login[:time_end] - login[:time_start]) / 60).to_i} minutes"
                         end
              "    from #{location_part} at #{start_part} (#{end_part})"
            end.join("\n")
          end
        <<~USER
            #{user}:
          #{logins_part}
          USER
      end.join("\n")}
    LAST
  end

  private

  def parse_last_logins(users)
    users.map do |(username, num_logins)|
      user_logins =
        `last --time-format=iso #{username}`
        .lines
        .select { |entry| entry.start_with?(username) }
        .take(num_logins)
        .map do |entry|
          data = entry.chomp.split(/(?:\s{2,})|(?:\s-\s)/)
          time_end = data[4] == 'still logged in' ? data[4] : Time.parse(data[4])
          {
            username: username,
            location: data[2],
            time_start: Time.parse(data[3]),
            time_end: time_end
          }
        end

      [username.to_sym, user_logins]
    end.to_h
  end
end
