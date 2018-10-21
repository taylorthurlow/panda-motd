require 'spec_helper'
require 'colorize'

describe ServiceStatus do
  before do
    stub_system_call(described_class_instance)
    described_class_instance.process
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class,
                                  'enabled' => true, 'services' => { 'plexmediaserver' => 'Plex', 'sonarr' => 'Sonarr' })
    }

    it 'returns the list of statuses' do
      expect(described_class_instance.results).to eq(plexmediaserver: :running, sonarr: :running)
    end

    it 'prints the list of statuses' do
      results = described_class_instance.to_s.delete(' ') # handle variable whitespace
      expect(results).to include 'plexmediaserver:' + 'running'.green
      expect(results).to include 'sonarr:' + 'running'.green
    end

    context 'when printing different statuses' do
      it 'prints running in green' do
        described_class_instance.instance_variable_set(:@results, servicename: :running)
        expect(described_class_instance.to_s).to include 'running'.green
      end

      it 'prints exited in white' do
        described_class_instance.instance_variable_set(:@results, servicename: :exited)
        expect(described_class_instance.to_s).to include 'exited'.white
      end

      it 'prints failed in red' do
        described_class_instance.instance_variable_set(:@results, servicename: :failed)
        expect(described_class_instance.to_s).to include 'failed'.red
      end
    end

    context 'when system call output is empty' do
      it 'adds an error to the component' do
        allow(described_class_instance).to receive(:`).and_return('')
        described_class_instance.process

        expect(described_class_instance.errors.count).to eq 1
        expect(described_class_instance.errors.first.message).to eq 'Unable to parse systemctl output'
      end
    end
  end

  context 'with config containing no services which were found' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'services' => { 'someservice' => 'Some Service' })
    }

    it 'returns the empty list' do
      expect(described_class_instance.results).to be_empty
    end

    it 'prints the empty list' do
      expect(described_class_instance.to_s).to include 'No matching services found.'
    end
  end
end
