# frozen_string_literal: true

require_relative 'player'
require_relative 'code_generator'
require_relative 'secret_code'
require_relative 'game_config'

# Represents a computer player in the game.
# Handles automatic code generation for making guesses and creating secret codes.
class ComputerPlayer < Player
  def initialize
    super('Computer', false)
  end

  # Makes a guess by generating a random code
  #
  # @param [Integer] code_length - number of colors the guess should contain
  # @return [Code] the code guessed by the computer player
  def make_guess(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    CodeGenerator.generate_random_code(code_length)
  end

  # Creates a secret code by generating a random code
  #
  # @param [Integer] code_length - number of colors the code should contain
  # @return [Code] the secret code created by the computer player
  def create_secret_code(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    SecretCode.generate_secret_code(code_length)
  end
end
