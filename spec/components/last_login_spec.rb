require "spec_helper"

describe LastLogin do
  context "with normal config" do
    subject(:component) {
      create(:last_login, settings: { "users" => { "taylor" => 4 } })
    }

    it "returns the list of logins" do
      stub_system_call(component)
      component.process

      expect(component.results[:taylor][1]).to eq(
        username: "taylor",
        location: "192.168.1.101",
        time_start: Time.parse("2018-05-12T13:32:28-0700"),
        time_end: Time.parse("2018-05-12T13:35:39-0700"),
      )
    end

    it "prints the list of logins" do
      stub_system_call(component)
      component.process

      expect(component.to_s).to include "from 192.168.1.101 at 05/12/2018 " \
                                        "01:35PM (#{"still logged in".green})"
      expect(component.to_s).to include "from 192.168.1.101 at 05/11/2018 " \
                                        "07:56PM (#{"gone - no logout".yellow})"
      expect(component.to_s).to include "from 192.168.1.101 at 05/12/2018 " \
                                        "01:32PM (3 minutes)"
    end

    context "when there are no logins found for a user" do
      it "prints a message" do
        component.config["users"] = { "stoyan" => 2 }
        stub_system_call(component)
        component.process

        expect(component.to_s).to include "no logins found for user"
      end
    end
  end
end
