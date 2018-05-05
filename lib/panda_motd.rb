require 'require_all'
require_rel 'panda_motd'

class PandaMOTD
  def self.new_motd
    return MOTD.new
  end
end
