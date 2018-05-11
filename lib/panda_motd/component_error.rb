require 'colorize'

class ComponentError
  def initialize(component, message)
    @component = component
    @message = message
  end

  def to_s
    return "#{@component.name} error: ".red + @message.to_s
  end
end
