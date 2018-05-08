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
