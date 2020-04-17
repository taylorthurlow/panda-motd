# typed: true
# frozen_string_literal: true

require "date"

class SSLCertificates < Component
  def initialize(motd)
    super(motd, "ssl_certificates")
  end

  # @see Component#process
  def process
    @certs = @config["certs"]
    @results = cert_dates(@certs)
  end

  # Prints the list of SSL certificates with their statuses. If a certificate
  # is not found at the configured location, a message will be printed which
  # explains this.
  def to_s
    <<~HEREDOC
      SSL Certificates:
      #{sorted_results.map do |cert|
      return "  #{cert}" if cert.is_a? String # print the not found message

      parse_cert(cert)
    end.join("\n")}
    HEREDOC
  end

  private

  # Takes an entry from `@results` and formats it in a way that is conducive
  # to being printed in the context of the MOTD.
  #
  # @param cert [Array] a two-element array in the same format as the return
  #   value of {#parse_result}
  def parse_cert(cert)
    name_portion = cert[0].ljust(longest_cert_name_length + 6, " ")
    status_sym = cert_status(cert[1])
    status = cert_status_strings[status_sym].to_s
    colorized_status = status.colorize(cert_status_colors[status_sym])
    date_portion = cert[1].strftime("%e %b %Y %H:%M:%S%p")
    "  #{name_portion} #{colorized_status} #{date_portion}"
  end

  # Determines the length of the longest SSL certificate name for use in
  # formatting the output of the component.
  #
  # @return [Integer] the length of the longest certificate name
  def longest_cert_name_length
    @results.map { |r| r[0].length }.max
  end

  # Takes the results array and sorts it according to the configured sort
  # method. If the option is not set or is set improperly, it will default to
  # alphabetical.
  def sorted_results
    if @config["sort_method"] == "alphabetical"
      @results.sort_by { |c| c[0] }
    elsif @config["sort_method"] == "expiration"
      @results.sort_by { |c| c[1] }
    else # default to alphabetical
      @results.sort_by { |c| c[0] }
    end
  end

  # Takes a list of certificates and compiles a list of results for each
  # certificate. If a certificate was not found, a notice will be returned
  # instead.
  #
  # @return [Array] An array of parsed results. If there was an error, the
  #   element will be just a string. If it was successful, the element will be
  #   another two-element array in the same format as the return value of
  #   {#parse_result}.
  def cert_dates(certs)
    certs.map do |name, path|
      if File.exist?(path)
        parse_result(name, path)
      else
        "Certificate #{name} not found at path: #{path}"
      end
    end.compact # remove nil entries, will have nil if error ocurred
  end

  # Uses `openssl` to obtain and parse and expiration date for the certificate.
  #
  # @param name [String] the name of the SSL certificate
  # @param path [String] the file path to the SSL certificate
  #
  # @return [Array] A pair where the first element is the configured name of
  #   the SSL certificate, and the second element is the expiration date of
  #   the certificate.
  def parse_result(name, path)
    cmd_result = `openssl x509 -in #{path} -dates`
    # match indices: 1 - month, 2 - day, 3 - time, 4 - year, 5 - zone
    exp = /notAfter=([A-Za-z]+) (\d+) ([\d:]+) (\d{4}) ([A-Za-z]+)\n/
    parsed = cmd_result.match(exp)

    if parsed.nil?
      @errors << ComponentError.new(self, "Unable to find certificate " \
                                          "expiration date")
      nil
    else
      expiry_date = Time.parse([1, 2, 4, 3, 5].map { |n| parsed[n] }.join(" "))
      [name, expiry_date]
    end
  rescue ArgumentError
    @errors << ComponentError.new(self, "Found expiration date, but unable " \
                                        "to parse as date")
    [name, Time.now]
  end

  # Maps an expiration date to a symbol representing the expiration status of
  # an SSL certificate.
  #
  # @param expiry_date [Time] the time at which the certificate expires
  #
  # @return [Symbol] A symbol representing the expiration status of the
  #   certificate. Valid values are `:expiring`, `:expired`, and `:valid`.
  def cert_status(expiry_date)
    if (Time.now...Time.now + 30).cover? expiry_date # ... range excludes last
      :expiring
    elsif Time.now >= expiry_date
      :expired
    else
      :valid
    end
  end

  # Maps a certificate expiration status to a color that represents it.
  def cert_status_colors
    {
      valid: :green,
      expiring: :yellow,
      expired: :red,
    }
  end

  # Maps a certificate expiration status to a string which can be prefixed to
  # the expiration date, to aid in explaining when the certificate expires.
  def cert_status_strings
    {
      valid: "valid until",
      expiring: "expiring at",
      expired: "expired at",
    }
  end
end
