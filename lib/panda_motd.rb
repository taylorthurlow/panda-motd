require 'require_all'
require_all 'lib/**/*.rb'

class PandaMOTD
  def self.new_motd
    return MOTD.new
  end
end
