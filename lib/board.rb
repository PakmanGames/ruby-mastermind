# frozen_string_literal: true

##
# Board represents the game board, displayus all the codes entered and pins
class Board
  attr_accessor :secret_code, :moves, :current_pins

  ##
  # Create a new board described by +secret_code
  #
  # +secret_code is the code the code breaker is meant to guess
  def initialize(secret_code)
    @secret_code = secret_code
    # Store the entire history of moves in this array
    @moves = []
    @current_pins = Array.new(4)
  end

  # Checks for winner based on the pin colors and length
  #
  # @return [Boolean] true or false if there's a winner
  def check_winner
    current_pins.all? { |pin| pin == :red } && current_pins.length == 4
  end
end
