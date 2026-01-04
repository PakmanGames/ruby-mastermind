# frozen_string_literal: true

# Represents a player in the game, which can be either human or computer-controlled.
class Player
  attr_reader :name, :human

  # Create a new player
  #
  # @param [Boolean] human - whether the player is human or not
  # @param [Boolean] code_maker - whether the player is a code maker or not
  def initialize(human, code_maker)
    @human = human
    @code_maker = code_maker
    @name = human ? prompt_for_name : 'Computer'
  end

  private

  # Prompts the player for their name
  #
  # @return [String] the player's name
  def prompt_for_name
    puts "What's your name? #{@code_maker ? '(Code Maker)' : '(Code Breaker)'}"
    gets.strip.chomp
  end
end
