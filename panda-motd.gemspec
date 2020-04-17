# frozen_string_literal: true

$LOAD_PATH << File.expand_path("lib", __dir__)
require "panda_motd/version"

Gem::Specification.new do |s|
  s.name = "panda-motd"
  s.version = PandaMOTD::VERSION
  s.licenses = ["MIT"]
  s.summary = "Make your MOTD prettier, and more useful."
  s.description = "Enhance your MOTD with useful at-a-glance information."
  s.authors = ["Taylor Thurlow"]
  s.email = "taylorthurlow@me.com"
  s.files = Dir["{bin,lib}/**/*"]
  s.homepage = "https://github.com/taylorthurlow/panda-motd"
  s.executables = ["panda-motd"]
  s.platform = "ruby"
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.4"

  s.add_dependency("artii", "~> 2.1")
  s.add_dependency("colorize", "~> 0.8")
  s.add_dependency("require_all", "~> 2.0")
  s.add_dependency("ruby-units", "~> 2.3")
  s.add_dependency("sysinfo", "~> 0.8")

  s.add_development_dependency("factory_bot")
  s.add_development_dependency("guard")
  s.add_development_dependency("guard-rspec")
  s.add_development_dependency("pry")
  s.add_development_dependency("pry-byebug")
  s.add_development_dependency("rspec")
  s.add_development_dependency("rubocop")
  s.add_development_dependency("rubocop-rspec")
  s.add_development_dependency("rufo")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("solargraph")
end
