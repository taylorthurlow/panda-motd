Dir['lib/panda_motd/**/*.rb'].each { |r| require r.gsub(%r{lib\/|\.rb}, '') }

class PandaMOTD
  def self.new_motd
    return MOTD.new
  end
end
