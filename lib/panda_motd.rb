Dir['lib/panda_motd/**/*'].each { |r| require r.gsub(%r{lib\/|\.rb}, '') }

class PandaMOTD
end
