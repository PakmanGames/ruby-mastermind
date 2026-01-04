# frozen_string_literal: true

require 'rainbow'

# Represents a code consisting of 4 colors.
class Code
  attr_reader :code_data

  # Create a new code
  #
  # @param [Array] colors - an array of symbols representing the colors
  # @param [Array] rainbow_colors - an array of each color colored for nice output
  def initialize(colors, rainbow_colors)
    @code_data = {
      colors:,
      rainbow_colors:
    }
  end

  # Creates new code specified by each color
  #
  # @param [Symbol] color1 - the first color
  # @param [Symbol] color2 - the second color
  # @param [Symbol] color3 - the third color
  # @param [Symbol] color4 - the fourth color
  # @return [Code] a new code object
  def self.create_new_code(color1, color2, color3, color4)
    colors = [color1, color2, color3, color4]
    rainbow_colors = colorize(colors)
    Code.new(colors, rainbow_colors)
  end

  # Colorizes the colors in the array
  #
  # @param [Array] colors - an array of symbols representing the colors
  # @return [Array] an array of each color colored for nice output
  def self.colorize(colors)
    colors.map { |color| Rainbow(color).color(color).bg(:black).bright }
  end

  # Pretty format to display the code
  #
  # @return [String] each color separated by spaces and '|'
  def to_s
    code_data[:rainbow_colors].inject('| ') { |acc, curr| "#{acc + curr} | " }
  end
end
