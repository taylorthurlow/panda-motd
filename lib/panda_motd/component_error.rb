# frozen_string_literal: true

require "colorize"

class ComponentError
  attr_reader :component, :message

  def initialize(component, message)
    @component = component
    @message = message
  end

  def to_s
    return "#{@component.name} error: ".red + @message.to_s
  end
end
