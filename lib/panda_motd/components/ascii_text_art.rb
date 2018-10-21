require 'artii'
require 'colorize'

class ASCIITextArt
  attr_reader :name, :errors, :results

  def initialize(motd)
    @name = 'ascii_text_art'
    @motd = motd
    @config = motd.config.component_config(@name)
    @errors = []
  end

  def process
    @text = `hostname`

    begin
      @art = Artii::Base.new font: @config['font']
      @results = @art.asciify(@text)
      @results = @results.colorize(@config['color'].to_sym) if @config['color']
    rescue Errno::EISDIR # Artii doesn't handle invalid font names very well
      @errors << ComponentError.new(self, 'Invalid font name')
    end
  end

  def to_s
    return @results
  end
end
