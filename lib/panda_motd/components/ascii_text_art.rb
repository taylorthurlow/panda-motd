require 'artii'
require 'colorize'

class ASCIITextArt
  attr_reader :name, :errors

  def initialize(motd)
    @name = 'ascii_text_art'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    @text = `hostname`
    @art = Artii::Base.new font: @config['font']
  end

  def to_s
    return @art.asciify(@text).send(@config['color'].to_sym)
  end
end
