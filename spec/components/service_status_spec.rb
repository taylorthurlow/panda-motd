require 'spec_helper'
require 'colorize'

describe ServiceStatus do
  before do
    stub_system_call(described_class_instance, 'active')
    described_class_instance.process
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class,
                                  'enabled' => true, 'services' => { 'plexmediaserver' => 'Plex', 'sonarr' => 'Sonarr' })
    }

    it 'returns the list of statuses' do
      expect(described_class_instance.results).to eq(Plex: :active, Sonarr: :active)
    end

    it 'prints the list of statuses' do
      # require 'byebug'
      # debugger
      results = described_class_instance.to_s.delete(' ') # handle variable whitespace
      expect(results).to include 'Plex:' + 'active'.green
      expect(results).to include 'Sonarr:' + 'active'.green
    end

    context 'when printing different statuses' do
      it 'prints active in green' do
        described_class_instance.instance_variable_set(:@results, servicename: :active)
        expect(described_class_instance.to_s).to include 'active'.green
      end

      it 'prints inactive in red' do
        described_class_instance.instance_variable_set(:@results, servicename: :inactive)
        expect(described_class_instance.to_s).to include 'inactive'.red
      end
    end

    context 'when system call output is empty' do
      it 'adds an error to the component' do
        stub_system_call(described_class_instance, '')
        described_class_instance.process

        expect(described_class_instance.errors.count).to eq 2
        expect(described_class_instance.errors.first.message).to eq 'Unable to parse systemctl output'
      end
    end
  end
end
