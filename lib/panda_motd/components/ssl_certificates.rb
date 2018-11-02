require 'date'

class SSLCertificates < Component
  def initialize(motd)
    super(motd, 'ssl_certificates')
  end

  def process
    @certs = @config['certs']
    @results = cert_dates(@certs)
  end

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

  def parse_cert(cert)
    name_portion = cert[0].ljust(longest_cert_name_length + 6, ' ')
    status_sym = cert_status(cert[1])
    status = cert_status_strings[status_sym].to_s
    colorized_status = status.colorize(cert_status_colors[status_sym])
    date_portion = cert[1].strftime('%e %b %Y %H:%M:%S%p')
    "  #{name_portion} #{colorized_status} #{date_portion}"
  end

  def longest_cert_name_length
    @results.map { |r| r[0].length }.max
  end

  def sorted_results
    if @config['sort_method'] == 'alphabetical'
      @results.sort_by { |c| c[0] }
    elsif @config['sort_method'] == 'expiration'
      @results.sort_by { |c| c[1] }
    else # default to alphabetical
      @results.sort_by { |c| c[0] }
    end
  end

  def cert_dates(certs)
    certs.map do |name, path|
      if File.exist?(path)
        parse_result(name, path)
      else
        "Certificate #{name} not found at path: #{path}"
      end
    end.compact # remove nil entries, will have nil if error ocurred
  end

  def parse_result(name, path)
    cmd_result = `openssl x509 -in #{path} -dates`
    # match indices: 1 - month, 2 - day, 3 - time, 4 - year, 5 - zone
    exp = /notAfter=([A-Za-z]+) (\d+) ([\d:]+) (\d{4}) ([A-Za-z]+)\n/
    parsed = cmd_result.match(exp)

    if parsed.nil?
      @errors << ComponentError.new(self, 'Unable to find certificate '\
                                          'expiration date')
      nil
    else
      expiry_date = Time.parse([1, 2, 4, 3, 5].map { |n| parsed[n] }.join(' '))
      [name, expiry_date]
    end
  rescue ArgumentError
    @errors << ComponentError.new(self, 'Found expiration date, but unable '\
                                        'to parse as date')
    [name, Time.now]
  end

  def cert_status(expiry_date)
    if (Time.now...Time.now + 30).cover? expiry_date # ... range excludes last
      :expiring
    elsif Time.now >= expiry_date
      :expired
    else
      :valid
    end
  end

  def cert_status_colors
    {
      valid: :green,
      expiring: :yellow,
      expired: :red
    }
  end

  def cert_status_strings
    {
      valid: 'valid until',
      expiring: 'expiring at',
      expired: 'expired at'
    }
  end
end
