require 'rainbow'

class SecretCode
  @@COLORS = %i[red green blue yellow black silver magenta cyan]

  def initialize(color1, color2, color3, color4)
    @color1 = color1
    @color2 = color2
    @color3 = color3
    @color4 = color4
  end
  attr_reader :color1, :color2, :color3, :color4

  def self.generate_secret_code
    SecretCode.new(@@COLORS.sample, @@COLORS.sample, @@COLORS.sample, @@COLORS.sample)
  end

  def to_s
    "| #{color1} | #{color2} | #{color3} | #{color4} |"
  end
end
