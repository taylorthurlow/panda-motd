require 'yaml'
require 'fileutils'

class Config
  attr_reader :file_path

  def initialize(file_path = nil)
    @file_path = file_path || File.join(Dir.home, '.config', 'panda-motd.yaml')
    unless File.exist?(@file_path)
      create_config(@file_path)
      puts "panda-motd created a default config file at: #{@file_path}"
    end
    load_config(@file_path)
  end

  def components_enabled
    # iterate config hash and grab names of enabled components
    enabled = @config['components'].map { |c, s| c if s['enabled'] }.compact
    # get the class constant
    enabled.map { |e| Config.component_classes[e.to_sym] }
  end

  def component_config(component_name)
    @config['components'][component_name.to_s]
  end

  def self.component_classes
    {
      ascii_text_art: ASCIITextArt,
      service_status: ServiceStatus,
      uptime: Uptime,
      ssl_certificates: SSLCertificates,
      filesystems: Filesystems,
      last_login: LastLogin,
      fail_2_ban: Fail2Ban
    }
  end

  private

  def create_config(file_path)
    default_config_path = File.join(
      File.dirname(__dir__), 'panda_motd', 'default_config.yaml'
    )
    FileUtils.cp(default_config_path, file_path)
  end

  def load_config(file_path)
    @config = YAML.safe_load(File.read(file_path))
    @config['components'] = [] if @config['components'].nil?
  end
end
