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

  # Creates a new code from any number of colors.
  # Accepts a variable number of colors so codes of any configured length
  # (see GameConfig) can be built from the same factory.
  #
  # @param [Array<Symbol>] colors - the colors making up the code
  # @return [Code] a new code object
  def self.create_new_code(*colors)
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
