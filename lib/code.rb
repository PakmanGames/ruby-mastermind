require 'rainbow'

class Code
  def initialize(colors, rainbow_colors)
    @code_data = {
      colors: colors,
      rainbow_colors: rainbow_colors
    }
  end
  attr_reader :code_data

  def self.create_new_code(color1, color2, color3, color4)
    colors = [color1, color2, color3, color4]
    rainbow_colors = colorize(colors)
    Code.new(colors, rainbow_colors)
  end

  def self.colorize(colors)
    colors.map { |color| Rainbow(color).color(color).bg(:black).bright }
  end

  def to_s
    code_data[:rainbow_colors].inject('| ') { |acc, curr| "#{acc + curr} | " }
  end
end
