# frozen_string_literal: true

require 'rainbow'

# Manages the generation and display of feedback pins based on the secret code and the player's guess.
module Pins
  # Creates pins based on the secret code and the player's guess
  #
  # @param [SecretCode] secret_code - the secret code to be guessed
  # @param [Code] guess - the code the code breaker guessed
  # @return [Hash] a hash containing the pins and the colored pins
  def self.generate_pins(secret_code, guess)
    pins = build_pins(secret_code, guess)
    {
      pins:,
      rainbow_pins: colorize(pins)
    }
  end

  # Builds the pins based on the secret code and the player's guess
  #
  # @param [SecretCode] secret_code - the secret code to be guessed
  # @param [Code] guess - the code the code breaker guessed
  # @return [Array] an array of symbols representing the pins
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
  # @param [Array] colors - an array of symbols representing the colors
  # @return [Array] an array of each color colored for nice output
  def self.colorize(colors)
    colors.map { |color| Rainbow(color).color(color).bg(:black).bright }
  end

  # Pretty format to display the pins
  #
  # @param [Hash] pins - a hash containing the pins and the colored pins
  # @return [String] a string representing the pins in a pretty format
  def self.display(pins)
    pins[:rainbow_pins].inject('-') { |acc, curr| "#{acc + curr}-" }
  end
end
