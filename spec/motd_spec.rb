require 'spec_helper'

describe MOTD do
  let(:described_class_instance) {
    config_path = File.join('spec', 'fixtures', 'configs', 'basic_config.yaml')
    described_class.new(config_path)
  }

  it 'creates a new MOTD' do
    expect(described_class_instance).not_to be_nil
  end

  it 'prints the MOTD' do
    expect(described_class_instance.to_s).not_to be_nil
  end

  context 'when errors exist' do
    before do
      errored_component = described_class_instance.components.first
      errored_component.errors << ComponentError.new(errored_component, 'something broke')
    end

    it 'prints the errors' do
      expect(described_class_instance.to_s).to include 'something broke'
    end
  end
end
