require 'spec_helper'
require 'colorize'

describe ServiceStatus do
  let(:service_status) { described_class.new(services) }

  context 'when on macos' do
    let(:services) { { chunkwm: 'chunkwm', skhd: 'skhd' } }
    let(:list_response) {
      file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'service_status', 'macos_services_output.txt')
      file = File.open(file_path)
      contents = file.read
      file.close

      return contents
    }

    before do
      allow(Gem::Platform.local).to receive(:os).and_return('darwin')
      allow(service_status).to receive(:`).and_return(list_response)
      service_status.parse_services
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
    let(:services) { { plexmediaserver: 'Plex', sonarr: 'Sonarr' } }
    let(:list_response) {
      file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'service_status', 'linux_services_output.txt')
      file = File.open(file_path)
      contents = file.read
      file.close

      return contents
    }

    before do
      allow(Gem::Platform.local).to receive(:os).and_return('linux')
      allow(service_status).to receive(:`).and_return(list_response)
      service_status.parse_services
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
