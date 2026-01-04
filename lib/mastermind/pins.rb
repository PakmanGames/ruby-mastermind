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
    secret_colors = secret_code.code_data[:colors].dup
    guess_colors = guess.code_data[:colors]
    pins = []
    matched_secret_indices = []
    matched_guess_indices = []

    # First pass: find red pins
    guess_colors.each_with_index do |color, index|
      next unless color == secret_colors[index]

      pins << :red
      matched_secret_indices << index
      matched_guess_indices << index
    end

    # Second pass: find white pins
    guess_colors.each_with_index do |color, guess_index|
      next if matched_guess_indices.include?(guess_index)

      secret_colors.each_with_index do |secret_color, secret_index|
        next if matched_secret_indices.include?(secret_index)

        next unless color == secret_color

        pins << :white
        matched_secret_indices << secret_index
        matched_guess_indices << guess_index
        break
      end
    end

    pins
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
