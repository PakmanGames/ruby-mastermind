# frozen_string_literal: true

# Handles all display-related functionality for the Mastermind game.
# This module contains stateless utility methods for formatting and displaying game information.
module GameDisplay
  # Displays the player matchup
  #
  # @param [Player] code_maker - the player who creates the secret code
  # @param [Player] code_breaker - the player who tries to break the secret code
  # @return [Nil] - the player matchup is displayed
  def self.player_matchup(code_maker, code_breaker)
    puts "#{code_maker.name} (Code Maker) vs #{code_breaker.name} (Code Breaker)"
  end

  # Displays the win message
  #
  # @param [Player] code_breaker - the player who broke the code
  # @param [Integer] turn - the current turn number
  # @return [Nil] - the win message is displayed
  def self.win_message(code_breaker, turn)
    puts "\nCODE HAS BEEN BROKEN!!"
    puts "Congratulations #{code_breaker.name} you successfully broke the code in #{turn} rounds!"
  end

  # Displays the loss message
  #
  # @param [SecretCode] secret_code - the secret code that wasn't broken
  # @return [Nil] - the loss message is displayed
  def self.loss_message(secret_code)
    puts "\nUnfortunately, it looks like you weren't able to break the code :("
    puts 'YOU LOSE!'
    puts "The secret code was: #{secret_code}"
  end

  # Displays the board
  #
  # @param [Board] board - the game board containing move history
  # @return [Nil] - the board is displayed
  def self.board(board)
    board.moves.last(12).each { |move| puts "\n#{move}" }
  end

  # Displays the round header
  #
  # @param [Integer] turn - the current turn number
  # @param [Player] code_breaker - the player making the guess
  # @return [Nil] - the round header is displayed
  def self.round_header(turn, code_breaker)
    puts "\nROUND #{turn}"
    puts "#{code_breaker.name} guess what the secret code might be: "
  end

  # Displays the welcome message
  #
  # @return [Nil] - the welcome message is displayed
  def self.welcome_message
    puts 'Welcome to Mastermind!'
    puts 'The code breaker gets a set number of turns to break a code the code maker creates.'
    puts 'Which type of game do you want to play?'
    puts '(Note that the first player will always be the code maker)'
    puts 'Type the corresponding number to choose a game type: '
  end
end
