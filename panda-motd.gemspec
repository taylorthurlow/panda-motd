$LOAD_PATH << File.expand_path('lib', __dir__)
require 'panda_motd/version'

Gem::Specification.new do |s|
  s.name        = 'panda-motd'
  s.version     = PandaMOTD::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Make your MOTD prettier, and more useful.'
  s.description = 'Enhance your MOTD with useful at-a-glance information.'
  s.authors     = ['Taylor Thurlow']
  s.email       = 'taylorthurlow8@gmail.com'
  s.files       = Dir['{bin,lib}/**/*']
  s.homepage    = 'https://github.com/taylorthurlow/panda-motd'
  s.executables = ['panda-motd']
  s.platform    = 'ruby'
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.3'

  # Dependencies
  s.add_dependency('artii', '~> 2.1')                            # generate text ascii art
  s.add_dependency('colorize', '~> 0.8')                         # easily color terminal output
  s.add_dependency('require_all', '~> 2.0')                      # easy requires
  s.add_dependency('ruby-units', '~> 2.3')                       # easy unit conversion
  s.add_dependency('sysinfo', '~> 0.8')                          # get system information easily

  s.add_development_dependency('factory_bot')                    # easy fixture data generation
  s.add_development_dependency('guard')                          # automatically watch files for changes
  s.add_development_dependency('guard-rspec')                    # rspec plugin for guard
  s.add_development_dependency('pry')                            # a console debugger
  s.add_development_dependency('pry-byebug')
  s.add_development_dependency('rspec')                          # testing framework
  s.add_development_dependency('rubocop')                        # help adhere to ruby syntax and best practices
  s.add_development_dependency('rubocop-rspec')                  # help adhere to ruby syntax and best practices
  s.add_development_dependency('simplecov')                      # code coverage analysis
end
