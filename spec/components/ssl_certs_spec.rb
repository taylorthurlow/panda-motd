require 'spec_helper'
require 'colorize'

describe SslCerts do
  let(:ssl_certs) {
    config_hash = {
      'enabled' => true,
      'password' => 'correcthorsebatterystaple',
      'certs' => {
        'taylorjthurlow.com' => '/etc/letsencrypt/live/taylorjthurlow.com/cert.pem'
      }
    }
    config = instance_double('config', component_config: config_hash)
    motd = instance_double('motd', config: config)
    return described_class.new(motd)
  }

  let(:cert_response) {
    file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'ssl_certs', 'output.txt')
    return File.read(file_path)
  }

  before do
    allow(ssl_certs).to receive(:`).and_return(cert_response)
    ssl_certs.process
  end

  it 'returns the list of certificates' do
    expect(ssl_certs.results).to eq([['taylorjthurlow.com', DateTime.parse('Jul 12 08:17:27 2018 GMT')]])
  end

  it 'prints the list of statuses' do
    results = ssl_certs.to_s.delete(' ') # handle variable whitespace
    expect(results).to include 'taylorjthurlow.com' + 'validuntil'.green
  end
end
