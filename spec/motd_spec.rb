require 'spec_helper'

describe MOTD do
  it 'creates a new MOTD' do
    config_path = File.join('spec', 'fixtures', 'configs', 'basic_config.yaml')
    described_class_instance = described_class.new(config_path)

    expect(described_class_instance).not_to be_nil
  end

  it 'prints the MOTD' do
    config_path = File.join('spec', 'fixtures', 'configs', 'basic_config.yaml')
    described_class_instance = described_class.new(config_path)

    expect(described_class_instance.to_s).not_to be_nil
  end
end
