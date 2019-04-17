require 'spec_helper'

describe Fail2Ban do
  context 'with normal config' do
    subject(:component) { create(:fail_2_ban) }

    it 'gets statistics' do
      stub_system_call(component)

      component.process

      expect(component.results).to eq(
        sshd: { total_bans: 122, total_unbans: 110 }
      )
    end

    it 'prints the results' do
      stub_system_call(component)

      component.process
      results = component.to_s

      expect(results).to include 'Fail2Ban:'
      expect(results).to include 'sshd:'
      expect(results).to include 'Total bans:   122'
      expect(results).to include 'Current bans: 12'
    end
  end

  context 'when a jail is skipped' do
    subject(:component) {
      create(:fail_2_ban, settings: { 'exclude_jails' => ['sshd'] })
    }

    it 'is not included in the results' do
      stub_system_call(component)

      component.process

      expect(component.results).to eq({})
    end
  end
end
