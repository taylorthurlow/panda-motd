require 'artii'
require 'colorize'

class AsciiTextArt
  def initialize(motd)
    @motd = motd
    @config = motd.config.component_config('ascii_text_art')
  end

  def process
    @text = `hostname`
    @art = Artii::Base.new font: @config['font']
  end

  def to_s
    return @art.asciify(@text).red
  end
end
