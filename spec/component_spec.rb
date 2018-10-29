require 'spec_helper'

describe Component do
  let(:motd) { instance_double(MOTD) }
  let(:config) { instance_double(Config) }
  let(:described_class_instance) {
    allow(motd).to receive(:config).and_return(config)
    allow(config).to receive(:component_config).with(nil).and_return({})
    described_class.new(motd, nil)
  }
  let(:variables_list) { [:name, :errors, :results] }

  it 'allows reading variables' do
    variables_list.each { |v| expect(described_class_instance.respond_to?(v)).to be true }
  end

  context '#process' do
    it 'raises an error' do
      expect { described_class_instance.process }.to raise_error(NotImplementedError)
    end
  end

  context '#to_s' do
    it 'raises an error' do
      expect { described_class_instance.to_s }.to raise_error(NotImplementedError)
    end
  end

  context '#lines_before' do
    it 'does not return nil' do
      expect(described_class_instance.lines_before).not_to be_nil
    end
  end

  context '#lines_after' do
    it 'does not return nil' do
      expect(described_class_instance.lines_after).not_to be_nil
    end
  end
end
