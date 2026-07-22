# frozen_string_literal: true

require_relative 'code'
require_relative 'code_generator'
require_relative 'game_config'

# Represents the secret code which will be hidden from the player as well as created to make guesses.
# Inherits from the Code class.
class SecretCode < Code
  # Class instance variables for available colors
  @colors = %i[red green blue yellow black silver magenta cyan]
  @colorized_colors = superclass.colorize(@colors).inject('-') { |acc, curr| "#{acc + curr}-" }

  # Generates a random secret code using CodeGenerator
  #
  # @param [Integer] code_length - number of colors in the code
  # @return [Code] a secret code that has just been randomly created
  def self.generate_secret_code(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    CodeGenerator.generate_random_code(code_length)
  end

  # Creates a code based on players input
  #
  # @param [Integer] code_length - number of colors the player must enter
  # @return [Code] a code created by the player
  def self.enter_code(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    display_color_options(code_length)
    code = collect_user_colors(code_length)
    create_new_code(code)
  end

  # Displays the color options to the player
  #
  # @param [Integer] code_length - number of colors the code will contain
  # @return [Nil]
  def self.display_color_options(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    puts "You can create a code from #{code_length} of the following colors: "
    puts @colorized_colors
    sleep(0.5)
    puts "\n"
  end

  # Collects the user's colors
  #
  # @param [Integer] code_length - number of colors to collect
  # @return [Array] an array of strings representing the colors
  def self.collect_user_colors(code_length = GameConfig::DEFAULT_CODE_LENGTH)
    code = []
    color = String.new
    until @colors.include?(color.to_sym) && code.length == code_length
      prompt_for_color
      color = gets.chomp
      code.push(color) if @colors.include?(color.to_sym)
    end
    code
  end

  # Prompts the user for a color
  #
  # @return [Nil]
  def self.prompt_for_color
    puts "Enter a color from this list: #{@colorized_colors}"
    puts '(Please enter the colors one at a time)'
  end

  # Creates a new code from an array of symbols
  #
  # @param [Array] colors - an array of strings representing the colors
  # @return [Code] represents the code the player just created
  def self.create_new_code(code)
    code.map!(&:to_sym)
    rainbow_code = superclass.colorize(code)
    Code.new(code, rainbow_code)
  end
end
