require 'artii'

class AsciiTextArt
  def initialize(text, font)
    @text = text
    @art = Artii::Base.new font: font
  end

  def to_s
    return "\n#{@art.asciify(@text)}\n"
  end
end
