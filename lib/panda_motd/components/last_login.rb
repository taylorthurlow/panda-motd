require 'date'

class LastLogin
  attr_reader :name, :errors, :results

  def initialize(motd)
    @name = 'last_login'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    @users = @config['users']
    @results = parse_last_logins(@users)
  end

  def to_s
    result = "Last Login:\n"

    @results.each do |user, logins|
      result += "  #{user}:\n"
      location_string_size = logins.map { |l| l[:location].length }.max
      logins.each do |login|
        location_part = login[:location].ljust(location_string_size, ' ')
        start_part = login[:time_start].strftime('%m/%d/%Y %I:%M%p')

        end_part = if login[:time_end].is_a? String # still logged in text
                     login[:time_end].green
                   else
                     "#{((login[:time_end] - login[:time_start]) * 24 * 60).to_i} minutes"
                   end

        result += "    from #{location_part} at #{start_part} (#{end_part})\n"
      end
      result += '    no logins found for user.' if logins.empty?
    end

    return result
  end

  private

  def parse_last_logins(users)
    all_logins = {}
    users.each_with_index do |(username, num_logins), i|
      user_logins = []
      cmd_result = `last --time-format=iso #{username}`
      cmd_result.split("\n").each do |entry|
        next unless entry.start_with? username
        data = entry.split(/(?:\s{2,})|(?:\s-\s)/)

        time_end = data[4] == 'still logged in' ? data[4] : DateTime.parse(data[4])

        user_logins << {
          username: username,
          location: data[2],
          time_start: DateTime.parse(data[3]),
          time_end: time_end
        }

        break if user_logins.count >= num_logins
      end

      all_logins[username.to_sym] = user_logins
    end

    return all_logins
  end
end
