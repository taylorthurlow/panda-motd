class Component
  attr_reader :name, :errors, :results, :config

  def initialize(motd, name)
    @name = name
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end

  def lines_before
    @motd.config.component_config(@name)["lines_before"] || 1
  end

  def lines_after
    @motd.config.component_config(@name)["lines_after"] || 1
  end
end
