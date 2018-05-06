require 'spec_helper'
require 'yaml'

describe Filesystems do
  let(:filesystems) {
    config_hash = { 'enabled' => true, 'filesystems' => { '/dev/sda1' => 'Ubuntu' } }
    config = instance_double('config', component_config: config_hash)
    motd = instance_double('motd', config: config)
    return described_class.new(motd)
  }

  let(:df_output) {
    file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'filesystems', 'output.txt')
    return File.read(file_path)
  }

  before do
    allow(filesystems).to receive(:`).and_return(df_output)
    filesystems.process
  end

  it 'returns the hash of filesystem info' do
    expect(filesystems.results).to eq [{
      pretty_name: 'Ubuntu',
      filesystem_name: '/dev/sda1',
      size: 111_331_104 * 1024,
      used: 70_005_864 * 1024,
      avail: 35_646_904 * 1024
    }]
  end

  it 'prints the filesystem info' do
    expect(filesystems.to_s).to include 'Ubuntu     114G   72G   37G'
  end
end
