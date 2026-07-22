# frozen_string_literal: true

require_relative 'code'
require_relative 'game_config'

# Generates random codes for computer players.
# Handles the creation of random codes from the available color palette.
class CodeGenerator
  # Available colors for code generation
  COLORS = %i[red green blue yellow black silver magenta cyan].freeze

  # Generates a random code of the requested length.
  # Colors are selected randomly with replacement (duplicates allowed).
  #
  # @param [Integer] code_length - number of colors in the code
  # @return [Code] a code object with randomly selected colors
  def self.generate_random_code(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    colors = Array.new(code_length) { COLORS.sample }
    Code.create_new_code(*colors)
  end
end
