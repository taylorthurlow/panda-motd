# typed: false
# frozen_string_literal: true

require "artii"
require "colorize"

class ASCIITextArt < Component
  def initialize(motd)
    super(motd, "ascii_text_art")
  end

  def process
    @text = `#{@config["command"]}`
    @art = Artii::Base.new font: @config["font"]
    @results = @art.asciify(@text)
    @results = @results.colorize(@config["color"].to_sym) if @config["color"]
  rescue Errno::EISDIR # Artii doesn't handle invalid font names very well
    @errors << ComponentError.new(self, "Invalid font name")
  end

  def to_s
    @results
  end
end
