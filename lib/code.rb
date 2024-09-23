# frozen_string_literal: true

require 'rainbow'

##
# This class represents the code which is an object of 4 colors specified by the player
class Code
  attr_reader :code_data

  ##
  # Create new code described by +colors and +rainbow_colors
  #
  # +colors is an array of symbols representing the colors
  # +rainbow_colors is an array of each color colored for nice output
  def initialize(colors, rainbow_colors)
    @code_data = {
      colors: colors,
      rainbow_colors: rainbow_colors
    }
  end

  # Creates new code specified by each color
  #
  # @param [Symbol] 4 symbols representing the colors
  # @return [Code Object] a code object
  def self.create_new_code(color1, color2, color3, color4)
    colors = [color1, color2, color3, color4]
    rainbow_colors = colorize(colors)
    Code.new(colors, rainbow_colors)
  end

  # Colorizes the items in the array
  #
  # @param [Array] of symbols representing colors
  # @return [Array] of each colored in color
  def self.colorize(colors)
    colors.map { |color| Rainbow(color).color(color).bg(:black).bright }
  end

  # Override to_s to make pretty output
  #
  # @return [String] each colour separated by spaces and '|'
  def to_s
    code_data[:rainbow_colors].inject('| ') { |acc, curr| "#{acc + curr} | " }
  end
end
