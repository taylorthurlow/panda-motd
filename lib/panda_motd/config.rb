require 'yaml'
require 'fileutils'

class Config
  def initialize(file_path = nil)
    @file_path = File.join(Dir.home, '.config', 'panda-motd.yaml') if file_path.nil?
    create_config(@file_path) unless File.exist?(@file_path)
    load_config(@file_path)
  end

  def components_enabled
    # first iterate through the config hash and grab all names of enabled components
    enabled_list = @config['components'].map { |component, setting| component if setting['enabled'] }.compact
    # convert each snake_case name to an upper-camel-case name which represents a class, and get that class constant
    return enabled_list.map { |e| Object.const_get(e.split('_').map(&:capitalize).join) }
  end

  def component_config(component_name)
    return @config['components'][component_name.to_s]
  end

  private

  def create_config(file_path)
    default_config_path = File.join(File.dirname(__dir__), 'panda_motd', 'default_config.yaml')
    FileUtils.cp(default_config_path, file_path)
  end

  def load_config(file_path)
    @config = YAML.safe_load(File.read(file_path))
  end
end
