# typed: false
# frozen_string_literal: true

require "yaml"
require "fileutils"

class Config
  attr_reader :file_path

  # @param file_path [String] The file path to look for the configuration file.
  #   If not provided, the default file path will be used.
  def initialize(file_path = nil)
    @file_path = file_path || File.join(Dir.home, ".config", "panda-motd.yaml")
    unless File.exist?(@file_path)
      create_config(@file_path)
      puts "panda-motd created a default config file at: #{@file_path}"
    end
    load_config(@file_path)
  end

  # A list of enabled components' class constants.
  def components_enabled
    # iterate config hash and grab names of enabled components
    enabled = @config["components"].map { |c, s| c if s["enabled"] }.compact
    # get the class constant
    enabled.map { |e| Config.component_classes[e.to_sym] }
  end

  # Gets the configuration for a component.
  #
  # @param component_name [String] the name of the component to fetch the
  #   configuration for
  def component_config(component_name)
    @config["components"][component_name.to_s]
  end

  # The mapping of component string names to class constants.
  def self.component_classes
    {
      ascii_text_art: ASCIITextArt,
      service_status: ServiceStatus,
      uptime: Uptime,
      ssl_certificates: SSLCertificates,
      filesystems: Filesystems,
      last_login: LastLogin,
      fail_2_ban: Fail2Ban,
    }
  end

  private

  # Creates a configuration file at a given file path, from the default
  # configuration file.
  #
  # @param file_path [String] the file path at which to create the config
  def create_config(file_path)
    default_config_path = File.join(
      File.dirname(__dir__), "panda_motd", "default_config.yaml"
    )
    FileUtils.cp(default_config_path, file_path)
  end

  # Loads a configuration file.
  #
  # @param file_path [String] the file path of the config to load
  def load_config(file_path)
    @config = YAML.safe_load(File.read(file_path))
    @config["components"] = [] if @config["components"].nil?
  end
end
