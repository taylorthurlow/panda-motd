# typed: true
# frozen_string_literal: true

require "module"

require "require_all"
require_rel "panda_motd"

class PandaMOTD
  # Creates a new MOTD instance, assuming a config file has been passed as an
  # argument to the command.
  def self.new_motd
    if ARGV[0].nil?
      puts "You must provide a config file path as an argument to panda-motd."
    else
      MOTD.new(ARGV[0])
    end
  end

  # Gets the root path of the gem.
  def self.root
    File.expand_path("..", __dir__)
  end
end
