spec = Gem::Specification.find_by_name('panda-motd')
Dir["#{spec.gem_dir}/lib/panda_motd/**/*.rb"].each { |f| load(f) }

class PandaMOTD
  def self.new_motd
    return MOTD.new
  end
end
