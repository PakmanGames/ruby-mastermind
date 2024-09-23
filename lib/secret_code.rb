# frozen_string_literal: true

require_relative 'code'

##
# This class represents the secret code which will be hidden from the player as well as created to make guesses
# Inherits from the Code class
class SecretCode < Code
  # Class variables as constants for each of the available colors
  @@COLORS = %i[red green blue yellow black silver magenta cyan]
  @@COLORIZED_COLORS = superclass.colorize(@@COLORS).inject('-') { |acc, curr| "#{acc + curr}-" }

  # Generates a random secret code using the superclass method
  #
  # @return [Code Object] a secret code that has just been randomly created
  def self.generate_secret_code
    superclass.create_new_code(@@COLORS.sample, @@COLORS.sample, @@COLORS.sample, @@COLORS.sample)
  end

  # Creates a code based on players input
  #
  # @return [Code Object] a code created by the player
  def self.enter_code
    puts 'You can create a code from 4 of the following colors: '
    puts @@COLORIZED_COLORS
    color = String.new
    code = []
    sleep(0.5)
    puts "\n"
    # Loop until correct input and code length is reached
    until @@COLORS.include?(color.to_sym) && code.length == 4
      puts "Enter a color from this list: #{@@COLORIZED_COLORS}"
      color = gets.chomp
      code.push(color) if @@COLORS.include?(color.to_sym)
    end
    create_new_code(code)
  end

  # Creates a new code from an array of symbols
  #
  # @param [Array] of symbols representing the colors
  # @return [Code Object] represents the code the player just created
  def self.create_new_code(code)
    code.map!(&:to_sym)
    rainbow_code = superclass.colorize(code)
    Code.new(code, rainbow_code)
  end
end
