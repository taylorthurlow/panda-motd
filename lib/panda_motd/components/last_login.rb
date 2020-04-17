# typed: true
# frozen_string_literal: true

require "date"

class LastLogin < Component
  sig { params(motd: MOTD).void }

  def initialize(motd)
    super(motd, "last_login")
  end

  sig { void }
  # @see Component#process
  def process
    @users = T.let(@config["users"], T.nilable(T::Hash[String, Integer]))
    @results = parse_last_logins
  end

  sig { returns(String) }
  # @see Component#to_s
  def to_s
    <<~HEREDOC
      Last Login:
      #{@results.map { |u, l| parse_result(u.to_s, l) }.join("\n")}
    HEREDOC
  end

  private

  sig do
    params(
      user: String, # the username to generate a string for
      logins: T::Array[T::Hash[Symbol, T.untyped]], # username keys with values containing login data
    ).returns(String) # the printable string for a single user
  end
  # Takes the list of processed results and generates a complete printable
  # component string.
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

  sig do
    params(
      login: T::Hash[T.untyped, T.untyped], # the login data, see {#hashify_login}
      longest_size: Integer, # the longest string length to help with string formatting
    ).returns(String) # the formatted string for printing
  end
  # Takes login data and converts it to a heplful printable string.
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

  sig { returns(T::Hash[Symbol, T::Array[T::Hash[Symbol, T.untyped]]]) }
  # Takes a list of configured usernames and grabs login data from the system.
  def parse_last_logins
    return {} unless @users

    @users.map do |(username, num_logins)|
      cmd_result = `last --time-format=iso #{username}`
      logins = cmd_result.lines
                         .select { |entry| entry.start_with?(username) }
                         .take(num_logins)

      [username.to_sym, logins.map { |l| hashify_login(l, username) }]
    end.to_h
  end

  sig do
    params(
      login: String, # the raw string result from the call to the system
      username: String, # the username of the logged user
    ).returns(T::Hash[Symbol, T.untyped]) # the parsed login entry data, with symbol keys
  end
  # A hash representation of a single login.
  def hashify_login(login, username)
    re = login.chomp.split(/(?:\s{2,})|(?<=\d)(?:\s-\s)/)

    if re[2..4].nil? || T.must(re[2..4]).any?(&:nil?)
      raise "Could not parse output from 'last' command: \n#{login}"
    end

    location = T.must(re[2])
    time_start = Time.parse(T.must(re[3]))
    time_end_raw = T.must(re[4])

    date = time_end_raw.scan(/\d{4}-\d{2}-[\dT:]+-\d{4}/)
    time_end = date.any? ? Time.parse(time_end_raw) : time_end_raw

    {
      username: username,     # string username
      location: location,     # string login location, an IP address
      time_start: time_start,
      time_end: time_end,     # Time or string, could be "still logged in"
    }
  end
end
