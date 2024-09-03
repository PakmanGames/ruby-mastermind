require 'rainbow'

module Colors
  def colorize(word)
    Rainbow(word).color(word.to_sym).bg(:black).bright
  end
end
