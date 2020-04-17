# typed: strong
# typed: true
# frozen_string_literal: true
class PandaMOTD
  # sord omit - no YARD return type given, using T.untyped
  # Creates a new MOTD instance, assuming a config file has been passed as an
  # argument to the command.
  sig { returns(T.untyped) }
  def self.new_motd; end

  # sord omit - no YARD return type given, using T.untyped
  # Gets the root path of the gem.
  sig { returns(T.untyped) }
  def self.root; end
end

class MOTD
  # Creates an MOTD by parsing the provided config file, and processing each
  # component.
  #
  # _@param_ `config_path` — The path to the configuration file. If not provided, the default config path will be used.
  #
  # _@param_ `process` — whether or not to actually process and evaluate the printable results of each component
  sig { params(config_path: T.nilable(String), process: T::Boolean).void }

  def initialize(config_path = nil, process = true); end

  # sord omit - no YARD return type given, using T.untyped
  # Takes each component on the MOTD and joins them together in a printable
  # format. It inserts two newlines in between each component, ensuring that
  # there is one empty line between each. If a component has any errors, the
  # error will be printed in a clean way.
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD type given for :config, using T.untyped
  # Returns the value of attribute config.
  sig { returns(T.untyped) }
  attr_reader :config

  # sord omit - no YARD type given for :components, using T.untyped
  # Returns the value of attribute components.
  sig { returns(T.untyped) }
  attr_reader :components
end

class Config
  # _@param_ `file_path` — The file path to look for the configuration file. If not provided, the default file path will be used.
  sig { params(file_path: T.nilable(String)).void }

  def initialize(file_path = nil); end

  # sord omit - no YARD return type given, using T.untyped
  # A list of enabled components' class constants.
  sig { returns(T.untyped) }

  def components_enabled; end

  # sord omit - no YARD return type given, using T.untyped
  # Gets the configuration for a component.
  #
  # _@param_ `component_name` — the name of the component to fetch the configuration for
  sig { params(component_name: String).returns(T.untyped) }

  def component_config(component_name); end

  # sord omit - no YARD return type given, using T.untyped
  # The mapping of component string names to class constants.
  sig { returns(T.untyped) }
  def self.component_classes; end

  # sord omit - no YARD return type given, using T.untyped
  # Creates a configuration file at a given file path, from the default
  # configuration file.
  #
  # _@param_ `file_path` — the file path at which to create the config
  sig { params(file_path: String).returns(T.untyped) }

  def create_config(file_path); end

  # sord omit - no YARD return type given, using T.untyped
  # Loads a configuration file.
  #
  # _@param_ `file_path` — the file path of the config to load
  sig { params(file_path: String).returns(T.untyped) }

  def load_config(file_path); end

  # sord omit - no YARD type given for :file_path, using T.untyped
  # Returns the value of attribute file_path.
  sig { returns(T.untyped) }
  attr_reader :file_path
end

# typed: true
# frozen_string_literal: true
class Component
  # sord omit - no YARD type given for "motd", using T.untyped
  # sord omit - no YARD type given for "name", using T.untyped
  sig { params(motd: T.untyped, name: T.untyped).void }

  def initialize(motd, name); end

  # sord omit - no YARD return type given, using T.untyped
  # Evaluates the component so that it has some meaningful output when it comes
  # time to print the MOTD.
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  # Gives the output of a component as a string.
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD return type given, using T.untyped
  # The number of lines to print before the component in the context of the
  # entire MOTD. 1 by default, if not configured.
  sig { returns(T.untyped) }

  def lines_before; end

  # sord omit - no YARD return type given, using T.untyped
  # The number of lines to print after the component in the context of the
  # entire MOTD. 1 by default, if not configured.
  sig { returns(T.untyped) }

  def lines_after; end

  # sord omit - no YARD type given for :name, using T.untyped
  # Returns the value of attribute name.
  sig { returns(T.untyped) }
  attr_reader :name

  # sord omit - no YARD type given for :errors, using T.untyped
  # Returns the value of attribute errors.
  sig { returns(T.untyped) }
  attr_reader :errors

  # sord omit - no YARD type given for :results, using T.untyped
  # Returns the value of attribute results.
  sig { returns(T.untyped) }
  attr_reader :results

  # sord omit - no YARD type given for :config, using T.untyped
  # Returns the value of attribute config.
  sig { returns(T.untyped) }
  attr_reader :config
end

class ComponentError
  # sord omit - no YARD type given for "component", using T.untyped
  # sord omit - no YARD type given for "message", using T.untyped
  sig { params(component: T.untyped, message: T.untyped).void }

  def initialize(component, message); end

  # sord omit - no YARD return type given, using T.untyped
  # Gets a printable error string in red.
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD type given for :component, using T.untyped
  # Returns the value of attribute component.
  sig { returns(T.untyped) }
  attr_reader :component

  # sord omit - no YARD type given for :message, using T.untyped
  # Returns the value of attribute message.
  sig { returns(T.untyped) }
  attr_reader :message
end

class Uptime < Component
  # sord omit - no YARD type given for "motd", using T.untyped
  sig { params(motd: T.untyped).void }

  def initialize(motd); end

  # sord omit - no YARD return type given, using T.untyped
  # Calculates the number of days, hours, and minutes based on the current
  # uptime value.
  #
  # _@see_ `Component#process`
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  # Gets a printable uptime string with a prefix. The prefix can be configured,
  # and defaults to "up".
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD return type given, using T.untyped
  # Formats the uptime values in such a way that it is easier to read. If any
  # of the measurements are zero, that part is omitted. Words are properly
  # pluralized.
  #
  # Examples:
  #
  # `3d 20h 55m` becomes `3 days, 20 hours, 55 minutes`
  #
  # `3d 0h 55m` becomes `3 days, 55 minutes`
  sig { returns(T.untyped) }

  def format_uptime; end

  # sord omit - no YARD type given for :days, using T.untyped
  # Returns the value of attribute days.
  sig { returns(T.untyped) }
  attr_reader :days

  # sord omit - no YARD type given for :hours, using T.untyped
  # Returns the value of attribute hours.
  sig { returns(T.untyped) }
  attr_reader :hours

  # sord omit - no YARD type given for :minutes, using T.untyped
  # Returns the value of attribute minutes.
  sig { returns(T.untyped) }
  attr_reader :minutes
end

# typed: true
# frozen_string_literal: true
class Fail2Ban < Component
  # sord omit - no YARD type given for "motd", using T.untyped
  sig { params(motd: T.untyped).void }

  def initialize(motd); end

  # sord omit - no YARD return type given, using T.untyped
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD type given for "jail", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(jail: T.untyped).returns(T.untyped) }

  def jail_status(jail); end
end

class Filesystems < Component
  # sord omit - no YARD type given for "motd", using T.untyped
  sig { params(motd: T.untyped).void }

  def initialize(motd); end

  # sord omit - no YARD return type given, using T.untyped
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD type given for "filesystem", using T.untyped
  # sord omit - no YARD type given for "size", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(filesystem: T.untyped, size: T.untyped).returns(T.untyped) }

  def format_filesystem(filesystem, size); end

  # sord omit - no YARD type given for "filesystem", using T.untyped
  # sord omit - no YARD type given for "size", using T.untyped
  # sord omit - no YARD type given for "percent_used", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(filesystem: T.untyped, size: T.untyped, percent_used: T.untyped).returns(T.untyped) }

  def generate_usage_bar(filesystem, size, percent_used); end

  # sord omit - no YARD type given for "percentage", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(percentage: T.untyped).returns(T.untyped) }

  def pct_color(percentage); end

  # sord omit - no YARD type given for "filesystem", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(filesystem: T.untyped).returns(T.untyped) }

  def calc_percent_used(filesystem); end

  # sord omit - no YARD type given for "percent_used", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(percent_used: T.untyped).returns(T.untyped) }

  def format_percent_used(percent_used); end

  # sord omit - no YARD type given for "value", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(value: T.untyped).returns(T.untyped) }

  def calc_metric(value); end

  # sord omit - no YARD type given for "filesystem", using T.untyped
  # sord omit - no YARD type given for "metric", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(filesystem: T.untyped, metric: T.untyped).returns(T.untyped) }

  def format_metric(filesystem, metric); end

  # sord omit - no YARD type given for "value", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(value: T.untyped).returns(T.untyped) }

  def calc_units(value); end

  # sord omit - no YARD type given for "filesystems", using T.untyped
  # sord omit - no YARD return type given, using T.untyped
  sig { params(filesystems: T.untyped).returns(T.untyped) }

  def parse_filesystem_usage(filesystems); end
end

class ASCIITextArt < Component
  # sord omit - no YARD type given for "motd", using T.untyped
  sig { params(motd: T.untyped).void }

  def initialize(motd); end

  # sord omit - no YARD return type given, using T.untyped
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  sig { returns(T.untyped) }

  def to_s; end
end

class ServiceStatus < Component
  # sord omit - no YARD type given for "motd", using T.untyped
  sig { params(motd: T.untyped).void }

  def initialize(motd); end

  # sord omit - no YARD return type given, using T.untyped
  #
  # _@see_ `Component#process`
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  # Gets a printable string to be printed in the MOTD. If there are no services
  # found in the result, it prints a warning message.
  sig { returns(T.untyped) }

  def to_s; end

  # Runs a `systemd` command to determine the state of a service. If the state
  # of the service was unable to be determined, an error will be added to the
  # component.
  #
  # _@param_ `service` — the name of the systemd service
  #
  # _@return_ — the state of the systemd service
  sig { params(service: String).returns(String) }

  def parse_service(service); end

  # Takes a list of services from a configuration file, and turns them into a
  # hash with the service states as values.
  #
  # _@param_ `services` — a two-element array where the first element is the name of the systemd service, and the second is the pretty name that represents it.
  #
  # _@return_ — * `key`: The symbolized name of the systemd service
  # * `value`: The symbolized service state
  sig { params(services: T::Array[T.untyped]).returns(T::Hash[T.untyped, T.untyped]) }

  def parse_services(services); end

  # sord omit - no YARD return type given, using T.untyped
  # A hash of mappings between a service state and a color which represents it.
  # The hash has a default value of red in order to handle unexpected service
  # status strings returned by `systemctl`.
  sig { returns(T.untyped) }

  def service_colors; end
end

class SSLCertificates < Component
  # sord omit - no YARD type given for "motd", using T.untyped
  sig { params(motd: T.untyped).void }

  def initialize(motd); end

  # sord omit - no YARD return type given, using T.untyped
  #
  # _@see_ `Component#process`
  sig { returns(T.untyped) }

  def process; end

  # sord omit - no YARD return type given, using T.untyped
  # Prints the list of SSL certificates with their statuses. If a certificate
  # is not found at the configured location, a message will be printed which
  # explains this.
  sig { returns(T.untyped) }

  def to_s; end

  # sord omit - no YARD return type given, using T.untyped
  # Takes an entry from `@results` and formats it in a way that is conducive
  # to being printed in the context of the MOTD.
  #
  # _@param_ `cert` — a two-element array in the same format as the return value of {#parse_result}
  sig { params(cert: T::Array[T.untyped]).returns(T.untyped) }

  def parse_cert(cert); end

  # Determines the length of the longest SSL certificate name for use in
  # formatting the output of the component.
  #
  # _@return_ — the length of the longest certificate name
  sig { returns(Integer) }

  def longest_cert_name_length; end

  # sord omit - no YARD return type given, using T.untyped
  # Takes the results array and sorts it according to the configured sort
  # method. If the option is not set or is set improperly, it will default to
  # alphabetical.
  sig { returns(T.untyped) }

  def sorted_results; end

  # sord omit - no YARD type given for "certs", using T.untyped
  # Takes a list of certificates and compiles a list of results for each
  # certificate. If a certificate was not found, a notice will be returned
  # instead.
  #
  # _@return_ — An array of parsed results. If there was an error, the
  # element will be just a string. If it was successful, the element will be
  # another two-element array in the same format as the return value of
  # {#parse_result}.
  sig { params(certs: T.untyped).returns(T::Array[T.untyped]) }

  def cert_dates(certs); end

  # Uses `openssl` to obtain and parse and expiration date for the certificate.
  #
  # _@param_ `name` — the name of the SSL certificate
  #
  # _@param_ `path` — the file path to the SSL certificate
  #
  # _@return_ — A pair where the first element is the configured name of
  # the SSL certificate, and the second element is the expiration date of
  # the certificate.
  sig { params(name: String, path: String).returns(T::Array[T.untyped]) }

  def parse_result(name, path); end

  # Maps an expiration date to a symbol representing the expiration status of
  # an SSL certificate.
  #
  # _@param_ `expiry_date` — the time at which the certificate expires
  #
  # _@return_ — A symbol representing the expiration status of the
  # certificate. Valid values are `:expiring`, `:expired`, and `:valid`.
  sig { params(expiry_date: Time).returns(Symbol) }

  def cert_status(expiry_date); end

  # sord omit - no YARD return type given, using T.untyped
  # Maps a certificate expiration status to a color that represents it.
  sig { returns(T.untyped) }

  def cert_status_colors; end

  # sord omit - no YARD return type given, using T.untyped
  # Maps a certificate expiration status to a string which can be prefixed to
  # the expiration date, to aid in explaining when the certificate expires.
  sig { returns(T.untyped) }

  def cert_status_strings; end
end
