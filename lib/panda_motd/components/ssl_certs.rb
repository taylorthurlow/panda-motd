require 'date'

class SslCerts
  attr_reader :results

  def initialize(motd)
    @motd = motd
    @config = motd.config.component_config('ssl_certs')
  end

  def process
    @certs = @config['certs']
    @results = cert_dates(@certs)
  end

  def to_s
    result = "SSL Certificates:\n"
    longest_name_size = @results.map { |r| r[0].length }.max

    @results.each_with_index do |cert, i|
      name_portion = "  #{cert[0]}".ljust(longest_name_size + 6, ' ')

      status = cert_status(cert[1])

      date_portion = "#{cert_status_strings[status]} ".send(cert_status_colors[status]) + cert[1].strftime('%e %b %Y %H:%M:%S%p').to_s
      result += name_portion + date_portion
      result += "\n" unless i == @results.count - 1 # don't print newline for last entry
    end

    return result
  end

  private

  def cert_dates(certs)
    return certs.map do |name, path|
      cmd_result = `openssl x509 -in #{path} -dates`
      expiry_date = DateTime.parse(cmd_result.match(/notAfter=([\w\s:]+)\n/)[1])
      [name, expiry_date]
    end
  end

  def cert_status(expiry_date)
    status = :valid
    status = :expiring if (DateTime.now - 30...DateTime.now).cover? expiry_date # ... range excludes end
    status = :expired if DateTime.now >= expiry_date
    return status
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
