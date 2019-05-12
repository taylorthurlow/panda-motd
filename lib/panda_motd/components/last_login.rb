# frozen_string_literal: true

require "date"

class LastLogin < Component
  def initialize(motd)
    super(motd, "last_login")
  end

  # @see Component#process
  def process
    @users = @config["users"]
    @results = parse_last_logins
  end

  # @see Component#to_s
  def to_s
    <<~HEREDOC
      Last Login:
      #{@results.map { |u, l| parse_result(u, l) }.join("\n")}
    HEREDOC
  end

  private

  # Takes the list of processed results and generates a complete printable
  # component string.
  #
  # @param user [String] the username to generate a string for
  # @param logins [Array<Hash>] an array of hashes with username keys and hash
  #   values containing the login data (see {#hashify_login})
  #
  # @return [String] the printable string for a single user
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

  # Takes login data and converts it to a heplful printable string.
  #
  # @param login [Hash] the login data, see {#hashify_login}
  # @param longest_size [Integer] the longest string length to help with string
  #   formatting
  #
  # @return [String] the formatted string for printing
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

  # Takes a list of configured usernames and grabs login data from the system.
  #
  # @return [Hash{Symbol => Hash}] a hash with username keys and hash values
  #   containing the login data (see {#hashify_login})
  def parse_last_logins
    @users.map do |(username, num_logins)|
      cmd_result = `last --time-format=iso #{username}`
      logins = cmd_result.lines
                         .select { |entry| entry.start_with?(username) }
                         .take(num_logins)

      [username.to_sym, logins.map! { |l| hashify_login(l, username) }]
    end.to_h
  end

  # A hash representation of a single login.
  #
  # @param login [String] the raw string result from the call to the system
  #   containing various bits of login information
  # @param username [String] the username of the logged user
  #
  # @return [Hash] the parsed login entry data, with symbol keys
  def hashify_login(login, username)
    re = login.chomp.split(/(?:\s{2,})|(?<=\d)(?:\s-\s)/)
    date = re[4].scan(/\d{4}-\d{2}-[\dT:]+-\d{4}/)

    time_end = date.any? ? Time.parse(re[4]) : re[4]

    {
      username: username,             # string username
      location: re[2],                # string login location, an IP address
      time_start: Time.parse(re[3]),
      time_end: time_end,             # Time or string, could be "still logged in"
    }
  end
end
