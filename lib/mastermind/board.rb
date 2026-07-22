# frozen_string_literal: true

require_relative 'game_config'

# Manages the game board state, tracking all moves made by the code breaker and the corresponding pins.
class Board
  attr_accessor :moves, :current_pins
  attr_reader :code_length

  # Create a new board
  #
  # @param [Integer] code_length - number of pegs per code, sizing the pin row
  def initialize(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    @moves = [] # History of moves
    @code_length = code_length
    @current_pins = Array.new(code_length)
  end

  # Checks for winner based on the pin colors and length
  #
  # @return [Boolean] true if the code breaker has won, false otherwise
  def check_winner
    return false if current_pins.nil? || current_pins.length != code_length

    current_pins.all? { |pin| pin == :red }
  end
end
