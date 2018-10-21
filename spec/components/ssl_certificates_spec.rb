require 'spec_helper'
require 'colorize'

describe SSLCertificates do
  before do
    stub_system_call(described_class_instance)
    allow(File).to receive(:exist?).and_return(true) # assume all cert file paths valid
    described_class_instance.process
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'certs' => {
        'taylorjthurlow.com' => '/etc/letsencrypt/live/taylorjthurlow.com/cert.pem' }
      )
    }

    it 'returns the list of certificates' do
      expect(described_class_instance.results).to eq([['taylorjthurlow.com', DateTime.parse('Jul 12 08:17:27 2018 GMT')]])
    end

    # FIXME: expired SSL certificate
    xit 'prints the list of statuses' do
      results = described_class_instance.to_s.delete(' ') # handle variable whitespace
      expect(results).to include 'taylorjthurlow.com' + 'validuntil'.green
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

  context 'with config containing certificates that are not found' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'certs' => {
        'taylorjthurlow.com' => '/etc/letsencrypt/live/taylorjthurlow.com/cert.pem' }
      )
    }

    it 'prints that the certificate was not found' do
      allow(File).to receive(:exist?).and_return(false) # assume cert file path is invalid
      described_class_instance.process

      expect(described_class_instance.to_s).to include 'Certificate taylorjthurlow.com not found'
    end
  end
end
