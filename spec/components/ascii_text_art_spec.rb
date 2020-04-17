# typed: false
# frozen_string_literal: true

require "spec_helper"
require "colorize"

describe ASCIITextArt do
  context "with normal config" do
    subject(:component) { create(:ascii_text_art) }

    it "prints the properly colored art" do
      stub_system_call(component, returns: "helloworld")
      component.process

      expect(component.results).to start_with "\e[0;31;49m" # code for red
      expect(component.results).to end_with "\e[0m"
    end

    it "prints the art" do
      stub_system_call(component, returns: "helloworld")
      component.process

      expect(component.to_s).not_to be_nil
    end
  end

  context "with config containing an invalid font name" do
    subject(:component) {
      create(:ascii_text_art, settings: { "font" => "badfontname" })
    }

    it "adds an error to the component" do
      stub_system_call(component, returns: "helloworld")
      component.process

      expect(component.errors.count).to eq 1
      expect(component.errors.first.message).to eq "Invalid font name"
    end
  end
end
