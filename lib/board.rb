# frozen_string_literal: true

# Manages the game board state, tracking all moves made by the code breaker and the corresponding pins.
class Board
  attr_accessor :secret_code, :moves, :current_pins

  # Create a new board
  #
  # @param [SecretCode] secret_code - the secret code to be guessed
  def initialize(secret_code)
    @secret_code = secret_code
    @moves = [] # History of moves
    @current_pins = Array.new(4)
  end

  # Checks for winner based on the pin colors and length
  #
  # @return [Boolean] true if the code breaker has won, false otherwise
  def check_winner
    current_pins.all? { |pin| pin == :red } && current_pins.length == 4
  end
end
