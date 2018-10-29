require 'date'

class SSLCertificates < Component
  def initialize(motd)
    @name = 'ssl_certificates'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    @certs = @config['certs']
    @results = cert_dates(@certs)
  end

  def to_s
    longest_name_size = @results.map { |r| r[0].length }.max
    sorted_results = if @config['sort_method'] == 'alphabetical'
                       @results.sort_by! { |c| c[0] }
                     elsif @config['sort_method'] == 'expiration'
                       @results.sort_by! { |c| c[1] }
                     else # default to alphabetical
                       @results.sort_by! { |c| c[0] }
                     end
    <<~HEREDOC
      SSL Certificates:
      #{@results.map do |cert|
          return "  #{cert}" if cert.is_a? String # print the not found message

          name_portion = cert[0].ljust(longest_name_size + 6, ' ')
          status = cert_status(cert[1])
          status = cert_status_strings[status].to_s.colorize(cert_status_colors[status])
          date_portion = cert[1].strftime('%e %b %Y %H:%M:%S%p')
          "  #{name_portion} #{status} #{date_portion}"
        end.join("\n")}
    HEREDOC
  end

  private

  def cert_dates(certs)
    return certs.map do |name, path|
      if File.exist?(path)
        cmd_result = `openssl x509 -in #{path} -dates`
        parsed = cmd_result.match(/notAfter=([\w\s:]+)\n/)
        if parsed.nil?
          @errors << ComponentError.new(self, 'Unable to find certificate expiration date')
        else
          begin
            expiry_date = DateTime.parse(parsed[1])
            [name, expiry_date]
          rescue ArgumentError
            @errors << ComponentError.new(self, 'Found expiration date, but unable to parse as date')
            [name, DateTime.now]
          end
        end
      else
        "Certificate #{name} not found at path: #{path}"
      end
    end
  end

  def cert_status(expiry_date)
    if (DateTime.now...DateTime.now + 30).cover? expiry_date # ... range excludes end
      :expiring
    elsif DateTime.now >= expiry_date
      :expired
    else
      :valid
    end
  end

  def cert_status_colors
    return {
      valid: :green,
      expiring: :yellow,
      expired: :red
    }
  end

  def cert_status_strings
    return {
      valid: 'valid until',
      expiring: 'expiring at',
      expired: 'expired at'
    }
  end
end
