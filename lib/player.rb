# frozen_string_literal: true

##
# This class represents the player, which can be a human or not a human
class Player
  attr_reader :name, :human

  ##
  # Create a new player described by +human and +code_maker
  #
  # +human is a boolean representing whether the player is human or not.
  # +code_maker is a boolean, determines whether this player is a code_maker
  def initialize(human, code_maker)
    @name = 'Computer'
    @human = human
    return unless human

    # Gets the player name from console
    puts "What's your name? #{code_maker ? '(Code Maker)' : '(Code Breaker)'}"
    @name = gets.chomp
  end
end
