# typed: false
# frozen_string_literal: true

require "spec_helper"

describe MOTD do
  subject(:motd) { create(:motd) }

  it "creates a new MOTD" do
    expect(motd).not_to be_nil
  end

  it "prints the MOTD" do
    allow(motd.components.first).to receive(:format_uptime).and_return("")
    expect(motd.to_s).not_to be_nil
  end

  context "when errors exist" do
    it "prints the errors" do
      component = create(:uptime)
      component.errors << ComponentError.new(component, "something broke")
      motd.instance_variable_set(:@components, [component])

      expect(motd.to_s).to include "something broke"
    end
  end
end
