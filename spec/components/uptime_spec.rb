require 'spec_helper'

describe Uptime do
  let!(:sysinfo) { instance_double('sysinfo') }

  before do
    allow(SysInfo).to receive(:new).and_return(sysinfo)
    allow(sysinfo).to receive(:uptime).and_return(15.12394)
  end

  context 'when uptime is less than 1 day' do
    it 'formats the uptime' do
      uptime = described_class.new

      expect(uptime.to_s).to eq 'uptime: 15 hours, 7 minutes'
    end

    it 'gets the proper number of days' do
      uptime = described_class.new

      expect(uptime.days).to eq 0
    end

    it 'gets the proper number of hours' do
      uptime = described_class.new

      expect(uptime.hours).to eq 15
    end

    it 'gets the proper number of minutes' do
      uptime = described_class.new

      expect(uptime.minutes).to eq 7
    end

    context 'when hours is zero' do
      it 'does not show hours' do
        allow(sysinfo).to receive(:uptime).and_return(0.12394)

        uptime = described_class.new

        expect(uptime.to_s).to eq 'uptime: 7 minutes'
      end
    end
  end

  context 'when uptime is greater than 1 day' do
    before do
      allow(sysinfo).to receive(:uptime).and_return(51.59238)
    end

    it 'formats the uptime' do
      uptime = described_class.new

      expect(uptime.to_s).to eq 'uptime: 2 days, 3 hours, 35 minutes'
    end

    it 'gets the proper number of days' do
      uptime = described_class.new

      expect(uptime.days).to eq 2
    end

    it 'gets the proper number of hours' do
      uptime = described_class.new

      expect(uptime.hours).to eq 3
    end

    it 'gets the proper number of minutes' do
      uptime = described_class.new

      expect(uptime.minutes).to eq 35
    end

    context 'when hours is zero' do
      it 'shows hours' do
        allow(sysinfo).to receive(:uptime).and_return(48.12394)

        uptime = described_class.new

        expect(uptime.to_s).to eq 'uptime: 2 days, 0 hours, 7 minutes'
      end
    end
  end

  context 'when days is 1' do
    it 'does not pluralize' do
      allow(sysinfo).to receive(:uptime).and_return(29.12394)

      uptime = described_class.new

      expect(uptime.to_s).to eq 'uptime: 1 day, 5 hours, 7 minutes'
    end
  end

  context 'when hours is 1' do
    it 'does not pluralize' do
      allow(sysinfo).to receive(:uptime).and_return(49.12394)

      uptime = described_class.new

      expect(uptime.to_s).to eq 'uptime: 2 days, 1 hour, 7 minutes'
    end
  end

  context 'when minutes is 1' do
    it 'does not pluralize' do
      allow(sysinfo).to receive(:uptime).and_return(59.017)

      uptime = described_class.new

      expect(uptime.to_s).to eq 'uptime: 2 days, 11 hours, 1 minute'
    end
  end
end
