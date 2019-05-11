require "require_all"
require_rel "panda_motd"

class PandaMOTD
  def self.new_motd
    if ARGV[0].nil?
      puts "You must provide a config file path as an argument to panda-motd."
    else
      MOTD.new(ARGV[0])
    end
  end

  def self.root
    File.expand_path("..", __dir__)
  end
end
