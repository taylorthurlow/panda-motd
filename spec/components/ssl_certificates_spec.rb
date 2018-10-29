require 'spec_helper'
require 'colorize'

describe SSLCertificates do
  before do
    stub_system_call(described_class_instance)
    allow(File).to receive(:exist?).and_return(true) # assume all cert file paths valid
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'certs' => {
                                    'thurlow.io' => '/etc/letsencrypt/live/thurlow.io/cert.pem'
                                  })
    }

    it 'returns the list of certificates' do
      described_class_instance.process

      expect(described_class_instance.results).to eq([['thurlow.io', DateTime.parse('Jul 12 2018 08:17:27 GMT')]])
    end

    context 'when printing different statuses' do
      it 'prints a valid certificate' do
        described_class_instance.instance_variable_set(:@results, [['mycert', DateTime.now + 31]])

        expect(described_class_instance.to_s.delete(' ')).to include 'validuntil'.green
      end

      it 'prints an expiring certificate' do
        described_class_instance.instance_variable_set(:@results, [['mycert', DateTime.now + 1]])

        expect(described_class_instance.to_s.delete(' ')).to include 'expiringat'.yellow
      end

      it 'prints an expired certificate' do
        described_class_instance.instance_variable_set(:@results, [['mycert', DateTime.now]])

        expect(described_class_instance.to_s.delete(' ')).to include 'expiredat'.red
      end
    end

    context 'when the certificate expiration date cannot be found' do
      it 'adds an error to the component' do
        allow(described_class_instance).to receive(:`).and_return('')
        described_class_instance.process

        expect(described_class_instance.errors.count).to eq 1
        expect(described_class_instance.errors.first.message).to eq 'Unable to find certificate expiration date'
      end
    end

    context 'when the certificate expiration date is found but cannot be parsed' do
      it 'adds an error to the component' do
        allow(described_class_instance).to receive(:`).and_return("notAfter=somerandomgibberishhere\n")
        described_class_instance.process

        expect(described_class_instance.errors.count).to eq 1
        expect(described_class_instance.errors.first.message).to eq 'Found expiration date, but unable to parse as date'
      end
    end
  end

  context 'when config contains certificates that are not found' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'certs' => {
                                    'thurlow.io' => '/etc/letsencrypt/live/thurlow.io/cert.pem'
                                  })
    }

    it 'prints that the certificate was not found' do
      allow(File).to receive(:exist?).and_return(false) # assume cert file path is invalid
      described_class_instance.process

      expect(described_class_instance.to_s).to include 'Certificate thurlow.io not found'
    end
  end

  context 'when sorting is set to alphabetical' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'sort_method' => 'alphabetical',
                                  'certs' => {
                                    'def' => '/etc/letsencrypt/live/def.com/cert.pem',
                                    'abc' => '/etc/letsencrypt/live/abc.com/cert.pem',
                                    'xyz' => '/etc/letsencrypt/live/xyz.com/cert.pem'
                                  })
    }

    it 'prints the certificates in alphabetical order' do
      described_class_instance.process

      name_list = described_class_instance.to_s.split("\n").drop(1).map { |c| c.strip.match(/^(\S+)/)[1] }

      expect(name_list).to eq ['abc', 'def', 'xyz']
    end
  end

  context 'when sorting is set to expiration' do
    def systemctl_call(path)
      return "openssl x509 -in #{path} -dates"
    end

    def stubbed_return_expiry(month_shift)
      return "notAfter=#{(DateTime.now >> month_shift).strftime('%b %d %H:%M:%S %Y')}\n"
    end

    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'sort_method' => 'expiration',
                                  'certs' => {
                                    'def' => '/etc/letsencrypt/live/def.com/cert.pem',
                                    'abc' => '/etc/letsencrypt/live/abc.com/cert.pem',
                                    'xyz' => '/etc/letsencrypt/live/xyz.com/cert.pem'
                                  })
    }

    it 'prints the certificates in order of earliest expiration first' do
      allow(described_class_instance).to receive(:`)
        .with(systemctl_call('/etc/letsencrypt/live/def.com/cert.pem'))
        .and_return(stubbed_return_expiry(3))

      allow(described_class_instance).to receive(:`)
        .with(systemctl_call('/etc/letsencrypt/live/abc.com/cert.pem'))
        .and_return(stubbed_return_expiry(1))

      allow(described_class_instance).to receive(:`)
        .with(systemctl_call('/etc/letsencrypt/live/xyz.com/cert.pem'))
        .and_return(stubbed_return_expiry(2))

      described_class_instance.process

      name_list = described_class_instance.to_s.split("\n").drop(1).map { |c| c.strip.match(/^(\S+)/)[1] }

      expect(name_list).to eq ['abc', 'xyz', 'def']
    end
  end
end
