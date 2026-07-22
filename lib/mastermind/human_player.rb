# frozen_string_literal: true

require_relative 'player'
require_relative 'secret_code'
require_relative 'game_config'

# Represents a human player in the game.
# Handles user input for making guesses and creating secret codes.
class HumanPlayer < Player
  # Create a new human player
  #
  # @param [Boolean] code_maker - whether the player is a code maker (true) or code breaker (false)
  def initialize(code_maker)
    @code_maker = code_maker
    name = prompt_for_name
    super(name, true)
  end

  # Makes a guess by prompting the user for input
  #
  # @param [Integer] code_length - number of colors the guess should contain
  # @return [Code] the code guessed by the human player
  def make_guess(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    SecretCode.enter_code(code_length)
  end

  # Creates a secret code by prompting the user for input
  #
  # @param [Integer] code_length - number of colors the code should contain
  # @return [Code] the secret code created by the human player
  def create_secret_code(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    SecretCode.enter_code(code_length)
  end

  private

  # Prompts the player for their name
  #
  # @return [String] the player's name
  def prompt_for_name
    role_text = @code_maker ? '(Code Maker)' : '(Code Breaker)'
    puts "What's your name? #{role_text}"
    gets.strip.chomp
  end
end
