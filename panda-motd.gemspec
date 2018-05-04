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
  s.required_ruby_version = '>= 2.2'

  # Dependencies
  s.add_dependency('artii', '~> 2.1.2')                          # generate text ascii art
  s.add_dependency('sysinfo', '~> 0.8.0')                        # get system information easily
  s.add_dependency('tty-markdown', '~> 0.3.0')                   # pretty printing of markdown to the console

  s.add_development_dependency('byebug', '~> 10.0.2')            # a console debugger
  s.add_development_dependency('guard', '~> 2.14.2')             # automatically watch files for changes
  s.add_development_dependency('guard-rspec', '~> 4.7.3')        # rspec plugin for guard
  s.add_development_dependency('rspec', '~> 3.7.0')              # testing framework
  s.add_development_dependency('rubocop', '~> 0.51')             # help adhere to ruby syntax and best practices
  s.add_development_dependency('rubocop-rspec', '~> 1.25.1')     # help adhere to ruby syntax and best practices
end
