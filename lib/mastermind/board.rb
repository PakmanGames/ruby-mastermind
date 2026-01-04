# frozen_string_literal: true

# Manages the game board state, tracking all moves made by the code breaker and the corresponding pins.
class Board
  attr_accessor :moves, :current_pins

  # Create a new board
  def initialize
    @moves = [] # History of moves
    @current_pins = Array.new(4)
  end

  # Checks for winner based on the pin colors and length
  #
  # @return [Boolean] true if the code breaker has won, false otherwise
  def check_winner
    return false if current_pins.nil? || current_pins.length != 4

    current_pins.all? { |pin| pin == :red }
  end
end
