# frozen_string_literal: true

require_relative 'code'

# Generates random codes for computer players.
# Handles the creation of random 4-color codes from the available color palette.
class CodeGenerator
  # Available colors for code generation
  COLORS = %i[red green blue yellow black silver magenta cyan].freeze

  # Generates a random 4-color code
  # Colors are selected randomly with replacement (duplicates allowed)
  #
  # @return [Code] a code object with 4 randomly selected colors
  def self.generate_random_code
    colors = Array.new(4) { COLORS.sample }
    Code.create_new_code(*colors)
  end
end
