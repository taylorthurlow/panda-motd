require 'spec_helper'
require 'yaml'

describe Filesystems do
  context 'when on macos' do
    let(:filesystems) {
      config_hash = { 'enabled' => true, 'disks' => { '/dev/disk1s1' => 'Macintosh HD' } }
      config = instance_double('config', component_config: config_hash)
      motd = instance_double('motd', config: config)
      return described_class.new(motd)
    }

    let(:df_output) {
      file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'filesystems', 'macos_output.txt')
      return File.read(file_path)
    }

    before do
      allow(filesystems).to receive(:`).and_return(df_output)
      filesystems.process
    end

    it 'returns the hash of filesystem info' do
      expect(filesystems.results).to eq [{
        pretty_name: 'Macintosh HD',
        disk_name: '/dev/disk1s1',
        size: 118_284_248 * 1024,
        used: 94_640_420 * 1024,
        avail: 20_895_452 * 1024
      }]
    end

    it 'prints the filesystem info' do
      expect(filesystems.to_s).to include 'Macintosh HD    121G   97G   21G'
    end
  end

  context 'when on linux' do
    let(:filesystems) {
      config_hash = { 'enabled' => true, 'disks' => { '/dev/sda1' => 'Ubuntu' } }
      config = instance_double('config', component_config: config_hash)
      motd = instance_double('motd', config: config)
      return described_class.new(motd)
    }

    let(:df_output) {
      file_path = File.join(File.dirname(__dir__), 'fixtures', 'components', 'filesystems', 'linux_output.txt')
      return File.read(file_path)
    }

    before do
      allow(filesystems).to receive(:`).and_return(df_output)
      filesystems.process
    end

    it 'returns the hash of filesystem info' do
      expect(filesystems.results).to eq [{
        pretty_name: 'Ubuntu',
        disk_name: '/dev/sda1',
        size: 111_331_104 * 1024,
        used: 70_005_864 * 1024,
        avail: 35_646_904 * 1024
      }]
    end

    it 'prints the filesystem info' do
      expect(filesystems.to_s).to include 'Ubuntu     114G   72G   37G'
    end
  end
end
