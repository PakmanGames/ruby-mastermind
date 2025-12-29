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
    pins = build_pins(secret_code, guess)
    {
      pins: pins,
      rainbow_pins: colorize(pins)
    }
  end

  def self.build_pins(secret_code, guess)
    secret_colors = secret_code.code_data[:colors]
    guess.code_data[:colors].map.with_index do |color, index|
      if color == secret_colors[index]
        :red # Add red pin if color is correct and in the right spot
      elsif secret_colors.include?(color)
        :white # Add white pin if color is correct in the wrong spot
      end
    end.compact
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
