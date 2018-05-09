class ComponentError
  def initialize(component, message)
    @component = component
    @message = message
  end

  def to_s
    return "#{component.name} error: #{@message}"
  end
end
