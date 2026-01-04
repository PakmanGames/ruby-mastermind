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
    matched_secret_indices = Set.new
    matched_guess_indices = Set.new

    red_pins = find_red_pins(secret_colors, guess_colors, matched_secret_indices, matched_guess_indices)
    white_pins = find_white_pins(secret_colors, guess_colors, matched_secret_indices, matched_guess_indices)

    red_pins + white_pins
  end

  # Finds exact matches (red pins)
  #
  # @param [Array] secret_colors - the secret code colors
  # @param [Array] guess_colors - the guess colors
  # @param [Array] matched_secret_indices - array to track matched secret indices
  # @param [Array] matched_guess_indices - array to track matched guess indices
  # @return [Array] array of red pin symbols
  def self.find_red_pins(secret_colors, guess_colors, matched_secret_indices, matched_guess_indices)
    pins = []
    guess_colors.each_with_index do |color, index|
      next unless color == secret_colors[index]

      pins << :red
      matched_secret_indices << index
      matched_guess_indices << index
    end
    pins
  end

  # Finds color matches in wrong positions (white pins)
  #
  # @param [Array] secret_colors - the secret code colors
  # @param [Array] guess_colors - the guess colors
  # @param [Array] matched_secret_indices - array to track matched secret indices
  # @param [Array] matched_guess_indices - array to track matched guess indices
  # @return [Array] array of white pin symbols
  def self.find_white_pins(secret_colors, guess_colors, matched_secret_indices, matched_guess_indices)
    pins = []
    guess_colors.each_with_index do |color, guess_index|
      next if matched_guess_indices.include?(guess_index)

      match_index = find_matching_secret_index(color, secret_colors, matched_secret_indices)
      next unless match_index

      pins << :white
      matched_secret_indices << match_index
      matched_guess_indices << guess_index
    end
    pins
  end

  # Finds the index of a matching secret color for the given guess color
  #
  # @param [Symbol] color - the guess color to match
  # @param [Array] secret_colors - the secret code colors
  # @param [Array] matched_secret_indices - array to track matched secret indices
  # @return [Integer, nil] the index of the matching secret color, or nil if not found
  def self.find_matching_secret_index(color, secret_colors, matched_secret_indices)
    secret_colors.each_with_index do |secret_color, secret_index|
      next if matched_secret_indices.include?(secret_index)
      next unless color == secret_color

      return secret_index
    end
    nil
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
