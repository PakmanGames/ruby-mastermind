# frozen_string_literal: true

# Represents a player in the game, which can be either human or computer-controlled.
class Player
  attr_reader :name, :human

  # Create a new player
  #
  # @param [Boolean] human - whether the player is human or not
  # @param [Boolean] code_maker - whether the player is a code maker or not
  def initialize(human, code_maker)
    @name = 'Computer'
    @human = human
    return unless human

    # Prompt the player for their name
    puts "What's your name? #{code_maker ? '(Code Maker)' : '(Code Breaker)'}"
    @name = gets.chomp
  end
end
