require 'factory_bot'
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
  # set up factory_bot
  config.include FactoryBot::Syntax::Methods

  # silence stdout and stderr
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    unless defined?(Byebug)
      $stderr = File.open(File::NULL, 'w')
      $stdout = File.open(File::NULL, 'w')
    end
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # remove all temp files after suite finished
  config.after(:suite) do
    Dir['tmp/**/*'].each { |f| File.delete(f) }
  end
end

Dir[File.dirname(__FILE__) + '/matchers/**/*.rb'].each { |file| require file }

#####
# Helper methods
#####

def instance_with_configuration(described_class, config_hash)
  config = instance_double('config', component_config: config_hash)
  motd = instance_double('motd', config: config)
  return described_class.new(motd)
end

def stub_system_call(described_class_instance, returns = command_output(described_class_instance.class))
  allow(described_class_instance).to receive(:`).and_return(returns)
end

def command_output(component_class, file_name = 'output')
  class_to_string_regex = /(?<=[A-Z])(?=[A-Z][a-z])|(?<=[^A-Z])(?=[A-Z])|(?<=[A-Za-z])(?=[^A-Za-z])/
  component_name = component_class.to_s.split(class_to_string_regex).map(&:downcase).join('_')
  file_path = File.join(File.dirname(__dir__), 'spec', 'fixtures', 'components', component_name, "#{file_name}.txt")
  return File.read(file_path)
end
