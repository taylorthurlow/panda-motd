require 'artii'
require 'colorize'

class AsciiTextArt
  def initialize(text, font)
    @text = text
    @art = Artii::Base.new font: font
  end

  def to_s
    return "#{@art.asciify(@text)}".red
  end
end
