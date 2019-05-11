# frozen_string_literal: true

require "spec_helper"

describe Uptime do
  subject(:component) { create(:uptime) }

  let(:sysinfo) { instance_double("sysinfo") }

  context "when uptime is less than 1 day" do
    it "formats the uptime" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(15.12394)
      component.process

      expect(component.to_s).to eq "up 15 hours, 7 minutes"
    end

    it "gets the proper number of days" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(15.12394)
      component.process

      expect(component.days).to eq 0
    end

    it "gets the proper number of hours" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(15.12394)
      component.process

      expect(component.hours).to eq 15
    end

    it "gets the proper number of minutes" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(15.12394)
      component.process

      expect(component.minutes).to eq 7
    end

    context "when hours is zero" do
      it "does not show hours" do
        allow(SysInfo).to receive(:new).and_return(sysinfo)
        allow(sysinfo).to receive(:uptime).and_return(0.12394)
        component.process

        expect(component.to_s).to eq "up 7 minutes"
      end
    end
  end

  context "when uptime is greater than 1 day" do
    it "formats the uptime" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(51.59238)
      component.process

      expect(component.to_s).to eq "up 2 days, 3 hours, 35 minutes"
    end

    it "gets the proper number of days" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(51.59238)
      component.process

      expect(component.days).to eq 2
    end

    it "gets the proper number of hours" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(51.59238)
      component.process

      expect(component.hours).to eq 3
    end

    it "gets the proper number of minutes" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(51.59238)
      component.process

      expect(component.minutes).to eq 35
    end

    context "when hours is zero" do
      it "does not show hours" do
        allow(SysInfo).to receive(:new).and_return(sysinfo)
        allow(sysinfo).to receive(:uptime).and_return(48.12394)
        component.process

        expect(component.to_s).to eq "up 2 days, 7 minutes"
      end
    end
  end

  context "when days is 1" do
    it "does not pluralize" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(29.12394)
      component.process

      expect(component.to_s).to eq "up 1 day, 5 hours, 7 minutes"
    end
  end

  context "when hours is 1" do
    it "does not pluralize" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(49.12394)
      component.process

      expect(component.to_s).to eq "up 2 days, 1 hour, 7 minutes"
    end
  end

  context "when minutes is 1" do
    it "does not pluralize" do
      allow(SysInfo).to receive(:new).and_return(sysinfo)
      allow(sysinfo).to receive(:uptime).and_return(59.017)
      component.process

      expect(component.to_s).to eq "up 2 days, 11 hours, 1 minute"
    end
  end
end
