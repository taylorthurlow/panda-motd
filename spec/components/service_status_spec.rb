require 'spec_helper'
require 'colorize'
require 'yaml'

describe ServiceStatus do
  let(:service_status) {
    config_hash = {
      'enabled' => true,
      'services' => {
        'chunkwm' => 'chunkwm',
        'skhd' => 'skhd',
        'plexmediaserver' => 'Plex',
        'sonarr' => 'Sonarr'
      }
    }
    config = instance_double('config', component_config: config_hash)
    motd = instance_double('motd', config: config)
    return described_class.new(motd)
  }

  let(:list_response) {
    file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'service_status', 'output.txt')
    return File.read(file_path)
  }

  before do
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
