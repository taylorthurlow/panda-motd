require 'simplecov'

unless ENV['NO_COVERAGE']
  SimpleCov.start do
    add_filter '/vendor'
  end
end

require 'bundler/setup'
Bundler.setup

require 'panda_motd' # and any other gems you need

RSpec.configure do |config|
end

#####
# Helper methods
#####

def instance_with_configuration(described_class, config_hash)
  config = instance_double('config', component_config: config_hash)
  motd = instance_double('motd', config: config)
  return described_class.new(motd)
end

def stub_system_call(described_class_instance)
  allow(described_class_instance).to receive(:`).and_return(command_output(described_class_instance.class))
end

def command_output(component_class, file_name = 'output')
  class_to_string_regex = /(?<=[A-Z])(?=[A-Z][a-z])|(?<=[^A-Z])(?=[A-Z])|(?<=[A-Za-z])(?=[^A-Za-z])/
  component_name = component_class.to_s.split(class_to_string_regex).map(&:downcase).join('_')
  file_path = File.join(File.dirname(__dir__), 'spec', 'fixtures', 'components', component_name, "#{file_name}.txt")
  return File.read(file_path)
end
