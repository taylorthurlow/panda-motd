require 'spec_helper'

describe Component do
  subject(:component) {
    motd = create(:motd)
    allow(motd.config).to receive(:component_config).with('name').and_return({})
    described_class.new(motd, 'name')
  }

  it 'allows reading variables' do
    [:name, :errors, :results].each { |v| expect(component.respond_to?(v)).to be true }
  end

  context '#process' do
    it 'raises an error' do
      expect { component.process }.to raise_error(NotImplementedError)
    end
  end

  context '#to_s' do
    it 'raises an error' do
      expect { component.to_s }.to raise_error(NotImplementedError)
    end
  end

  context '#lines_before' do
    it 'does not return nil' do
      expect(component.lines_before).not_to be_nil
    end
  end

  context '#lines_after' do
    it 'does not return nil' do
      expect(component.lines_after).not_to be_nil
    end
  end
end
