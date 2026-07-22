# frozen_string_literal: true

# Represents a player in the game, which can be either human or computer-controlled.
# This is a base class that defines the interface for player behavior.
# Subclasses should implement make_guess and create_secret_code methods.
class Player
  attr_reader :name, :human

  # Create a new player
  #
  # @param [Boolean, String] human_or_name - whether the player is human (Boolean) or the player's name (String)
  # @param [Boolean] code_maker - whether the player is a code maker or not (optional if name provided)
  def initialize(human_or_name, code_maker = nil)
    if human_or_name.is_a?(String)
      @name = human_or_name
      @human = code_maker
      @code_maker = nil
    else
      # For backward compatibility
      @human = human_or_name
      @code_maker = code_maker
      @name = @human ? prompt_for_name : 'Computer'
    end
  end

  # Makes a guess at the secret code.
  # Subclasses must implement this method.
  #
  # @param [Integer] code_length - number of colors the guess should contain
  # @return [Code] the code guessed by the player
  # @raise [NotImplementedError] if called on base Player class
  def make_guess(_code_length = nil)
    raise NotImplementedError, "#{self.class} must implement make_guess"
  end

  # Creates a secret code.
  # Subclasses must implement this method.
  #
  # @param [Integer] code_length - number of colors the code should contain
  # @return [Code] the secret code created by the player
  # @raise [NotImplementedError] if called on base Player class
  def create_secret_code(_code_length = nil)
    raise NotImplementedError, "#{self.class} must implement create_secret_code"
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
