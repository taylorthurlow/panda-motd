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
    # get the class constant
    return enabled_list.map { |e| component_classes[e.to_sym] }
  end

  def component_config(component_name)
    return @config['components'][component_name.to_s]
  end

  private

  def component_classes
    return {
      ascii_text_art: ASCIITextArt,
      service_status: ServiceStatus,
      uptime: Uptime,
      ssl_certificates: SSLCertificates,
      filesystems: Filesystems
    }
  end

  def create_config(file_path)
    default_config_path = File.join(File.dirname(__dir__), 'panda_motd', 'default_config.yaml')
    FileUtils.cp(default_config_path, file_path)
  end

  def load_config(file_path)
    @config = YAML.safe_load(File.read(file_path))
  end
end
