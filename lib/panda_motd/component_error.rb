# typed: true
# frozen_string_literal: true

require "colorize"

class ComponentError
  attr_reader :component, :message

  def initialize(component, message)
    @component = component
    @message = message
  end

  # Gets a printable error string in red.
  def to_s
    return "#{@component.name} error: ".red + @message.to_s
  end
end
