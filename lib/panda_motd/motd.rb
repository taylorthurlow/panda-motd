class MOTD
  attr_accessor :text

  def initialize
    @text = 'hello world'
  end

  def to_s
    return @text
  end
end
