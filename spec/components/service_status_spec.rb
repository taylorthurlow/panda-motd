require "spec_helper"
require "colorize"

describe ServiceStatus do
  context "with normal config" do
    subject(:component) { create(:service_status) }

    it "returns the list of statuses" do
      stub_system_call(component, returns: "active")
      component.process

      expect(component.results).to eq(Plex: :active, Sonarr: :active)
    end

    it "prints the list of statuses" do
      stub_system_call(component, returns: "active")
      component.process

      results = component.to_s.delete(" ") # handle variable whitespace
      expect(results).to include "Plex" + "active".green
      expect(results).to include "Sonarr" + "active".green
    end

    context "when printing different statuses" do
      it "prints active in green" do
        component.instance_variable_set(:@results, servicename: :active)
        expect(component.to_s).to include "active".green
      end

      it "prints inactive in yellow" do
        component.instance_variable_set(:@results, servicename: :inactive)
        expect(component.to_s).to include "inactive".yellow
      end

      it "prints failed in red" do
        component.instance_variable_set(:@results, servicename: :failed)
        expect(component.to_s).to include "failed".red
      end

      it "prints unknown status in red" do
        component.instance_variable_set(:@results, servicename: :asdf123)
        expect(component.to_s).to include "asdf123".red
      end
    end

    context "when system call output is empty" do
      it "adds an error to the component" do
        stub_system_call(component, returns: "")
        component.process
        errors = component.errors

        expect(errors.count).to eq 2
        expect(errors.first.message).to eq "systemctl output was blank."
      end
    end
  end
end
