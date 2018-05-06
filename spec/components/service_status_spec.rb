require 'spec_helper'
require 'colorize'
require 'yaml'

describe ServiceStatus do
  let(:service_status) {
    config_hash = YAML.safe_load(File.read(File.join(File.dirname(__dir__), 'fixtures', 'components', 'service_status', 'config.yaml')))
    config = instance_double('config', component_config: config_hash)
    motd = instance_double('motd', config: config)
    return described_class.new(motd)
  }

  context 'when on macos' do
    let(:list_response) {
      file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'service_status', 'macos_services_output.txt')
      return File.read(file_path)
    }

    before do
      allow(Gem::Platform.local).to receive(:os).and_return('darwin')
      allow(service_status).to receive(:`).and_return(list_response)
      service_status.process
    end

    it 'returns the list of statuses' do
      expect(service_status.results).to eq(chunkwm: 'started'.green, skhd: 'started'.green)
    end

    it 'prints the list of statuses' do
      results = service_status.to_s.delete(' ') # handle variable whitespace
      expect(results).to include 'chunkwm:' + 'started'.green
      expect(results).to include 'skhd:' + 'started'.green
    end
  end

  context 'when on linux' do
    let(:list_response) {
      file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'service_status', 'linux_services_output.txt')
      return File.read(file_path)
    }

    before do
      allow(Gem::Platform.local).to receive(:os).and_return('linux')
      allow(service_status).to receive(:`).and_return(list_response)
      service_status.process
    end

    it 'returns the list of statuses' do
      expect(service_status.results).to eq('plexmediaserver': 'running'.green, 'sonarr': 'running'.green)
    end

    it 'prints the list of statuses' do
      results = service_status.to_s.delete(' ') # handle variable whitespace
      expect(results).to include 'plexmediaserver:' + 'running'.green
      expect(results).to include 'sonarr:' + 'running'.green
    end
  end
end
