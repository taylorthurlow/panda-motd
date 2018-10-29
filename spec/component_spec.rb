require 'spec_helper'

describe Component do
  let(:described_class_instance) { described_class.new }
  let(:variables_list) { [:name, :errors, :results] }

  it 'allows reading variables' do
    variables_list.each { |v| expect(described_class_instance.send(v)).to be_nil }
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
end
