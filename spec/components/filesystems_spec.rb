require 'spec_helper'
require 'colorize'

describe Filesystems do
  before do
    stub_system_call(described_class_instance)
    described_class_instance.process
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'filesystems' => { '/dev/sda1' => 'Ubuntu' })
    }

    it 'returns the hash of filesystem info' do
      expect(described_class_instance.results).to eq [{
        pretty_name: 'Ubuntu',
        filesystem_name: '/dev/sda1',
        size: 111_331_104 * 1024,
        used: 70_005_864 * 1024,
        avail: 35_646_904 * 1024
      }]
    end

    context 'when printing different units' do
      it 'prints in terabytes' do
        results_with_size(10**9)
        expect(described_class_instance.to_s).to include '1.0T'
      end

      it 'prints in gigabytes' do
        results_with_size(10**6)
        expect(described_class_instance.to_s).to include '1.0G'
      end

      it 'prints in megabytes' do
        results_with_size(10**3)
        expect(described_class_instance.to_s).to include '1.0M'
      end

      it 'prints in kilobytes' do
        results_with_size(10**0)
        expect(described_class_instance.to_s).to include '1.0K'
      end

      it 'prints with 3 whole numbers' do
        results_with_size(123 * 10**6)
        expect(described_class_instance.to_s).to include '126G'
      end

      it 'prints with 1 whole number and 1 decimal place' do
        results_with_size(1_300_000_000)
        expect(described_class_instance.to_s).to include '1.3T'
      end

      def results_with_size(size)
        described_class_instance.instance_variable_set(:@results, [{
          pretty_name: 'Ubuntu',
          filesystem_name: '/dev/sda1',
          size: size * 1024,
          used: (size * 0.5) * 1024,
          avail: 35_646_904 * 1024
        }])
      end
    end

    context 'when printing usage colors' do
      it 'uses green from 0 to 75' do
        results_with_ratio(0.0)
        expect(described_class_instance.to_s.delete(' ')).to include '0%'.green
        results_with_ratio(0.75)
        expect(described_class_instance.to_s.delete(' ')).to include '75%'.green
      end

      it 'uses yellow from 76 to 95' do
        results_with_ratio(0.76)
        expect(described_class_instance.to_s.delete(' ')).to include '76%'.yellow
        results_with_ratio(0.95)
        expect(described_class_instance.to_s.delete(' ')).to include '95%'.yellow
      end

      it 'uses red from 96 to 100' do
        results_with_ratio(0.96)
        expect(described_class_instance.to_s.delete(' ')).to include '96%'.red
        results_with_ratio(1.0)
        expect(described_class_instance.to_s.delete(' ')).to include '100%'.red
      end

      def results_with_ratio(ratio)
        described_class_instance.instance_variable_set(:@results, [{
          pretty_name: 'Ubuntu',
          filesystem_name: '/dev/sda1',
          size: 100_000 * 1024,
          used: (100_000 * ratio) * 1024,
          avail: 35_646_904 * 1024
        }])
      end
    end

    it 'prints the filesystem info' do
      expect(described_class_instance.to_s).to include 'Ubuntu     114G   72G   37G'
    end
  end

  context 'with config containing filesystems that are not found' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'filesystems' => { '/dev/notfound' => 'Ubuntu' })
    }

    it 'returns the hash of filesystem info' do
      expect(described_class_instance.results).to eq ['/dev/notfound was not found']
    end

    it 'prints the filesystem info' do
      expect(described_class_instance.to_s).to include '/dev/notfound was not found'
    end
  end
end
