# typed: true
# frozen_string_literal: true

require "spec_helper"
require "colorize"

describe SSLCertificates do
  context "with normal config" do
    subject(:component) { create(:ssl_certificates) }

    it "returns the list of certificates" do
      stub_system_call(component)
      allow(File).to receive(:exist?).and_return(true) # valid cert path
      component.process

      expect(component.results).to eq([[
                                     "thurlow.io",
                                     Time.parse("Jul 12 2018 08:17:27 GMT"),
                                   ]])
    end

    context "when printing different statuses" do
      it "prints a valid certificate" do
        component.instance_variable_set(:@results, [["mycert", Time.now + 31]])

        expect(component.to_s.delete(" ")).to include "validuntil".green
      end

      it "prints an expiring certificate" do
        component.instance_variable_set(:@results, [["mycert", Time.now + 1]])

        expect(component.to_s.delete(" ")).to include "expiringat".yellow
      end

      it "prints an expired certificate" do
        component.instance_variable_set(:@results, [["mycert", Time.now]])

        expect(component.to_s.delete(" ")).to include "expiredat".red
      end
    end

    context "when the certificate expiration date cannot be found" do
      it "adds an error to the component" do
        stub_system_call(component, returns: "")
        allow(File).to receive(:exist?).and_return(true) # valid cert path
        component.process

        expect(component.errors.count).to eq 1
        expect(component.errors.first.message).to eq(
          "Unable to find certificate expiration date"
        )
      end
    end

    context "when the certificate expiration date cannot be parsed" do
      it "adds an error to the component" do
        stub_system_call(
          component,
          returns: "notAfter=Wtf 69 42:42:42 2077 LOL\n",
        )
        allow(File).to receive(:exist?).and_return(true) # valid cert path
        component.process

        expect(component.errors.count).to eq 1
        expect(component.errors.first.message).to eq(
          "Found expiration date, but unable to parse as date"
        )
      end
    end

    context "when config contains certificates that are not found" do
      it "prints that the certificate was not found" do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?)
                         .with("/etc/letsencrypt/live/thurlow.io/cert.pem")
                         .and_return(false) # assume cert file path is invalid
        stub_system_call(component)
        component.process

        expect(component.to_s).to include "Certificate thurlow.io not found"
      end
    end
  end

  context "when sorting is set to alphabetical" do
    subject(:component) {
      settings = { "sort_method" => "alphabetical",
                  "certs" => {
        "def" => "/etc/letsencrypt/live/def.com/cert.pem",
        "abc" => "/etc/letsencrypt/live/abc.com/cert.pem",
        "xyz" => "/etc/letsencrypt/live/xyz.com/cert.pem",
      } }
      create(:ssl_certificates, settings: settings)
    }

    it "prints the certificates in alphabetical order" do
      stub_system_call(component)
      allow(File).to receive(:exist?).and_return(true) # valid cert path
      component.process

      name_list = component.to_s.split("\n")
                           .drop(1)
                           .map { |c| c.strip.match(/^(\S+)/)[1] }
      expect(name_list).to eq ["abc", "def", "xyz"]
    end
  end

  context "when sorting is set to expiration" do
    subject(:component) {
      settings = { "sort_method" => "expiration",
                  "certs" => {
        "def" => "/etc/letsencrypt/live/def.com/cert.pem",
        "abc" => "/etc/letsencrypt/live/abc.com/cert.pem",
        "xyz" => "/etc/letsencrypt/live/xyz.com/cert.pem",
      } }
      create(:ssl_certificates, settings: settings)
    }

    def systemctl_call(path)
      return "openssl x509 -in #{path} -dates"
    end

    def stubbed_return_expiry(time_shift)
      time = (Time.now + time_shift).strftime("%b %d %H:%M:%S %Y %Z")
      return "notAfter=#{time}\n"
    end

    it "prints the certificates in order of earliest expiration first" do
      allow(File).to receive(:exist?).and_return(true) # valid cert path

      allow(component).to receive(:`)
                            .with(systemctl_call("/etc/letsencrypt/live/def.com/cert.pem"))
                            .and_return(stubbed_return_expiry(3 * 60))

      allow(component).to receive(:`)
                            .with(systemctl_call("/etc/letsencrypt/live/abc.com/cert.pem"))
                            .and_return(stubbed_return_expiry(1 * 60))

      allow(component).to receive(:`)
                            .with(systemctl_call("/etc/letsencrypt/live/xyz.com/cert.pem"))
                            .and_return(stubbed_return_expiry(2 * 60))

      component.process

      name_list = component.to_s.split("\n")
                           .drop(1)
                           .map { |c| c.strip.match(/^(\S+)/)[1] }

      expect(name_list).to eq ["abc", "xyz", "def"]
    end
  end
end
