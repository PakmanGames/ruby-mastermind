# frozen_string_literal: true

require_relative 'player'
require_relative 'code_generator'
require_relative 'secret_code'

# Represents a computer player in the game.
# Handles automatic code generation for making guesses and creating secret codes.
class ComputerPlayer < Player
  def initialize
    super('Computer', false)
  end

  # Makes a guess by generating a random code
  #
  # @return [Code] the code guessed by the computer player
  def make_guess
    CodeGenerator.generate_random_code
  end

  # Creates a secret code by generating a random code
  #
  # @return [Code] the secret code created by the computer player
  def create_secret_code
    SecretCode.generate_secret_code
  end
end
