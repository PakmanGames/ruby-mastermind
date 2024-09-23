# frozen_string_literal: true

require 'rainbow'

##
# This module contains various methods necessary for creating the pins
module Pins
  # Create pins based on +secret_code and +guess
  #
  # @param [Array, Code Object], +secret_code is the code the code breaker guessed.
  # +guess is the code breaker's guess at what the +secret_code might be
  # @return [Hash] represents the pins, colored and uncolored
  def self.generate_pins(secret_code, guess)
    pins = []
    guess.code_data[:colors].each_with_index do |color, index|
      if color == secret_code.code_data.dig(:colors, index)
        pins.push(:red) # Add red pin if color is correct and in the right spot
      elsif secret_code.code_data[:colors].include?(color)
        pins.push(:silver) # Add silver pin if color is correct in the wrong spot
      end
    end
    rainbow_pins = colorize(pins)
    {
      pins: pins,
      rainbow_pins: rainbow_pins
    }
  end

  # Colorizes the pins
  #
  # @param [Array] of colors as symbols
  # @return [Array] of colored in pins
  def self.colorize(colors)
    colors.map { |color| Rainbow(color).color(color).bg(:black).bright }
  end

  # Pretty format to display the pins
  #
  # @param [Hash] representing the pins
  # @return [String] of the color pins in a pretty format
  def self.display(pins)
    pins[:rainbow_pins].inject('-') { |acc, curr| "#{acc + curr}-" }
  end
end
