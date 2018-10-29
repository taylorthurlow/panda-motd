require 'spec_helper'

describe LastLogin do
  before do
    stub_system_call(described_class_instance)
    described_class_instance.process
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'users' => { 'taylor' => 2 })
    }

    it 'returns the list of logins' do
      expect(described_class_instance.results).to eq(
        taylor: [
          {
            username: 'taylor',
            location: '192.168.1.101',
            time_start: Time.parse('2018-05-12T13:35:41-0700'),
            time_end: 'still logged in'
          },
          {
            username: 'taylor',
            location: '192.168.1.101',
            time_start: Time.parse('2018-05-12T13:32:28-0700'),
            time_end: Time.parse('2018-05-12T13:35:39-0700')
          }
        ]
      )
    end

    it 'prints the list of logins' do
      expect(described_class_instance.to_s).to include "from 192.168.1.101 at 05/12/2018 01:35PM (#{'still logged in'.green})"
      expect(described_class_instance.to_s).to include 'from 192.168.1.101 at 05/12/2018 01:32PM (3 minutes)'
    end

    context 'when there are no logins found for a user' do
      let(:described_class_instance) {
        instance_with_configuration(described_class, 'enabled' => true, 'users' => { 'stoyan' => 2 })
      }

      it 'prints a message' do
        expect(described_class_instance.to_s).to include 'no logins found for user'
      end
    end
  end
end
