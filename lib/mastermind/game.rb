# frozen_string_literal: true

require_relative 'player'
require_relative 'secret_code'
require_relative 'board'
require_relative 'pins'

# Main mastermind game.
# Holds the players, board state, turn count, guess state, and secret code.
class Game
  attr_reader :code_maker, :code_breaker
  attr_accessor :secret_code, :current_guess, :board, :turn

  # Create new instance of Game
  #
  # @param [Player] code_maker - the player who creates the secret code
  # @param [Player] code_breaker - the player who tries to break the secret code
  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = nil
    @current_guess = Code.new([], [])
    @board = Board.new(secret_code)
    @turn = 0
  end

  # Plays the game
  #
  # @return [Nil] - the game is played until the code is broken or the turn limit is reached
  def play_game
    display_player_matchup
    setup_secret_code
    play_rounds_until_complete
    display_game_result
  end

  # Displays the player matchup
  #
  # @return [Nil] - the player matchup is displayed
  def display_player_matchup
    puts "#{code_maker.name} (Code Maker) vs #{code_breaker.name} (Code Breaker)"
  end

  # Sets up the secret code
  #
  # @return [Nil] - the secret code is set up
  def setup_secret_code
    if code_maker.human
      setup_human_secret_code
    else
      setup_computer_secret_code
    end
    puts "Code generated! Now let's play!"
    sleep(1)
  end

  # Sets up the secret code for a human code maker
  #
  # @return [Nil] - the secret code is set up
  def setup_human_secret_code
    puts "\n#{code_maker.name} create a secret code that #{code_breaker.name} will try to guess."
    puts "Make sure you remember the code, you won't be able to see it again!"
    @secret_code = SecretCode.enter_code
    puts "\n" * 100 # Clear console to prevent code breaker from cheating
  end

  # Sets up the secret code for a computer code maker
  #
  # @return [Nil] - the secret code is set up
  def setup_computer_secret_code
    @secret_code = SecretCode.generate_secret_code
    board.secret_code = secret_code
  end

  # Plays rounds until the code is broken or the turn limit is reached
  #
  # @return [Nil] - the rounds are played until the code is broken or the turn limit is reached
  def play_rounds_until_complete
    play_round until board.check_winner || turn == 12
  end

  # Displays the game result
  #
  # @return [Nil] - the game result is displayed
  def display_game_result
    if board.check_winner
      display_win_message
    elsif turn == 12
      display_loss_message
    end
  end

  # Displays the win message
  #
  # @return [Nil] - the win message is displayed
  def display_win_message
    puts "\nCODE HAS BEEN BROKEN!!"
    puts "Congratulations #{code_breaker.name} you successfully broke the code in #{turn} rounds!"
  end

  # Displays the loss message
  #
  # @return [Nil] - the loss message is displayed
  def display_loss_message
    puts "\nUnfortunately, it looks like you weren't able to break the code :("
    puts 'YOU LOSE!'
    puts "The secret code was: #{secret_code}"
  end

  # Plays a round of mastermind
  #
  # @return [Nil] - the round is played until the code is broken or the turn limit is reached
  def play_round
    increment_turn_and_display
    current_guess = code_breaker_guess
    pins = generate_pins_for_guess(current_guess)
    process_and_display_results(current_guess, pins)
  end

  # Increments the turn and displays the round number
  #
  # @return [Nil] - the turn is incremented and the round number is displayed
  def increment_turn_and_display
    @turn += 1
    puts "\nROUND #{turn}"
    puts "#{code_breaker.name} guess what the secret code might be: "
  end

  # Code breaker guesses the secret code
  #
  # @return [Code] - the code the code breaker guessed
  def code_breaker_guess
    SecretCode.enter_code
  end

  # Generates pins for the guess
  #
  # @param [Code] current_guess - the code the code breaker guessed
  # @return [Hash] - the pins for the guess
  def generate_pins_for_guess(current_guess)
    Pins.generate_pins(secret_code, current_guess)
  end

  # Processes and displays the results of the guess
  #
  # @param [Code] current_guess - the code the code breaker guessed
  # @param [Hash] pins - the pins for the guess
  # @return [Nil] - the results are processed and displayed
  def process_and_display_results(current_guess, pins)
    results = format_guess_results(current_guess, pins)
    board.moves.append(results)
    display_board
    board.current_pins = pins[:pins]
  end

  # Formats the guess results
  #
  # @param [Code] current_guess - the code the code breaker guessed
  # @param [Hash] pins - the pins for the guess
  # @return [String] - the formatted guess results
  def format_guess_results(current_guess, pins)
    "#{current_guess} #{Pins.display(pins)}"
  end

  # Displays the board
  #
  # @return [Nil] - the board is displayed
  def display_board
    board.moves.each { |move| puts "\n#{move}" }
  end

  # Sets the game mode
  #
  # @return [Game] - the game object
  def self.choose_game
    display_welcome_message
    game_mode = collect_game_mode_choice
    check_game_mode(game_mode)
  end

  # Displays the welcome message
  #
  # @return [Nil] - the welcome message is displayed
  def self.display_welcome_message
    puts 'Welcome to Mastermind!'
    puts 'The code breaker has 12 turns to break a code the code maker creates.'
    puts 'Which type of game do you want to play?'
    puts '(Note that the first player will always be the code maker)'
    puts 'Type the corresponding number to choose a game type: '
  end

  # Collects the game mode choice
  #
  # @return [String] - the game mode choice
  def self.collect_game_mode_choice
    game_mode = String.new
    until [1, 2, 3].include?(game_mode.to_i)
      puts "(1) Human vs Human\n(2) Computer vs Human\n(3) Computer vs Computer"
      game_mode = gets.chomp
    end
    game_mode
  end

  # Creates the game based on the selected game mode
  #
  # @param [String] game_mode - the chosen game mode
  # @return [Game] - the game object
  def self.check_game_mode(game_mode)
    case game_mode.to_i
    when 1
      # Human vs Human
      Game.new(Player.new(true, true), Player.new(true, false))
    when 2
      # Computer vs Human
      Game.new(Player.new(false, true), Player.new(true, false))
    when 3
      # Computer vs Computer (TODO: implement)
      puts 'Work in progress'
      Game.new(Player.new(false, true), Player.new(false, false))
    end
  end
end
