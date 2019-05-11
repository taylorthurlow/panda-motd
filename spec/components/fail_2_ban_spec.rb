# frozen_string_literal: true

require "spec_helper"

describe Fail2Ban do
  context "with normal config" do
    subject(:component) { create(:fail_2_ban) }

    it "gets statistics" do
      stub_system_call(component)

      component.process

      expect(component.results[:jails]).to eq(
        "sshd" => { total: 871, current: 0 },
      )
    end

    it "prints the results" do
      stub_system_call(component)

      component.process
      results = component.to_s

      expect(results).to include "Fail2Ban:"
      expect(results).to include "Total bans:   871"
      expect(results).to include "Current bans: 0"
    end
  end

  context "with config containing an invalid jail name" do
    subject(:component) {
      create(:fail_2_ban, settings: { "jails" => ["asdf"] })
    }

    it "adds an error to the component" do
      stub_system_call(
        component,
        returns: "Sorry but the jail 'asdf' does not exist",
      )

      component.process

      expect(component.errors.count).to eq 1
      expect(component.errors.first.message).to eq "Invalid jail name 'asdf'."
    end
  end
end
