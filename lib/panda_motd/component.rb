class Component
  attr_reader :name, :errors, :results

  def process
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end
end
