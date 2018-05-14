require 'spec_helper'
require 'colorize'

describe ASCIITextArt do
  before do
    described_class_instance.process
  end

  context 'with normal config' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'font' => 'slant', 'color' => 'red', 'command' => 'hostname')
    }

    it 'prints the properly colored art' do
      expect(described_class_instance.results).to start_with "\e[0;31;49m" # escape codes for red text
      expect(described_class_instance.results).to end_with "\e[0m"
    end

    it 'prints the art' do
      expect(described_class_instance.to_s).not_to be_nil
    end
  end

  context 'with config containing an invalid font name' do
    let(:described_class_instance) {
      instance_with_configuration(described_class, 'enabled' => true, 'font' => 'badfontname', 'color' => 'red', 'command' => 'hostname')
    }

    it 'adds an error to the component' do
      expect(described_class_instance.errors.count).to eq 1
      expect(described_class_instance.errors.first.message).to eq 'Invalid font name'
    end
  end
end
