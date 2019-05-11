# frozen_string_literal: true

class Component
  attr_reader :name, :errors, :results, :config

  def initialize(motd, name)
    @name = name
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  # Evaluates the component so that it has some meaningful output when it comes
  # time to print the MOTD.
  def process
    raise NotImplementedError
  end

  # Gives the output of a component as a string.
  def to_s
    raise NotImplementedError
  end

  # The number of lines to print before the component in the context of the
  # entire MOTD. 1 by default, if not configured.
  def lines_before
    @motd.config.component_config(@name)["lines_before"] || 1
  end

  # The number of lines to print after the component in the context of the
  # entire MOTD. 1 by default, if not configured.
  def lines_after
    @motd.config.component_config(@name)["lines_after"] || 1
  end
end
