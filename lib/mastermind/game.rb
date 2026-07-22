# frozen_string_literal: true

require_relative 'player'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'secret_code'
require_relative 'board'
require_relative 'pins'
require_relative 'game_display'
require_relative 'game_config'

# Main mastermind game.
# Holds the players, board state, turn count, guess state, and secret code.
class Game
  attr_reader :code_maker, :code_breaker, :config
  attr_accessor :secret_code, :current_guess, :board, :turn

  # Create new instance of Game
  #
  # @param [Player] code_maker - the player who creates the secret code
  # @param [Player] code_breaker - the player who tries to break the secret code
  # @param [GameConfig] config - code length and turn limit for this game
  def initialize(code_maker, code_breaker, config = GameConfig.new)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @config = config
    @secret_code = nil
    @current_guess = Code.new([], [])
    @board = Board.new(config.code_length)
    @turn = 0
  end

  # Plays the game
  #
  # @return [Nil] - the game is played until the code is broken or the turn limit is reached
  def play_game
    GameDisplay.player_matchup(code_maker, code_breaker)
    board.moves.clear # Clear the board moves before starting a new game
    setup_secret_code
    play_rounds_until_complete
    display_game_result
  end

  # Sets up the secret code
  #
  # @return [Nil] - the secret code is set up
  def setup_secret_code
    announce_human_code_maker if code_maker.human
    @secret_code = code_maker.create_secret_code(config.code_length)
    puts "\n" * 100 if code_maker.human # Clear console to prevent code breaker from cheating
    # TODO: system('clear') || system('cls') to clear the console instead in the future
    puts "Code generated! Now let's play!"
    sleep(1)
  end

  # Tells a human code maker to create a code the code breaker won't see
  #
  # @return [Nil]
  def announce_human_code_maker
    puts "\n#{code_maker.name} create a secret code that #{code_breaker.name} will try to guess."
    puts "Make sure you remember the code, you won't be able to see it again!"
  end

  # Plays rounds until the code is broken or the turn limit is reached
  #
  # @return [Nil] - the rounds are played until the code is broken or the turn limit is reached
  def play_rounds_until_complete
    play_round until board.check_winner || turn >= config.turn_limit
  end

  # Displays the game result
  #
  # @return [Nil] - the game result is displayed
  def display_game_result
    if board.check_winner
      GameDisplay.win_message(code_breaker, turn)
    elsif turn >= config.turn_limit
      GameDisplay.loss_message(secret_code)
    end
  end

  # Plays a round of mastermind
  #
  # @return [Nil] - the round is played until the code is broken or the turn limit is reached
  def play_round
    increment_turn_and_display
    @current_guess = code_breaker_guess
    pins = generate_pins_for_guess(@current_guess)
    process_and_display_results(@current_guess, pins)
  end

  # Increments the turn and displays the round number
  #
  # @return [Nil] - the turn is incremented and the round number is displayed
  def increment_turn_and_display
    @turn += 1
    GameDisplay.round_header(turn, code_breaker)
  end

  # Code breaker guesses the secret code
  #
  # @return [Code] - the code the code breaker guessed
  def code_breaker_guess
    code_breaker.make_guess(config.code_length)
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
    GameDisplay.board(board)
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

  # Sets the game mode
  #
  # @return [Game] - the game object
  def self.choose_game
    GameDisplay.welcome_message
    game_mode = collect_game_mode_choice
    config = GameConfig.collect
    check_game_mode(game_mode, config)
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
  # @param [GameConfig] config - code length and turn limit for this game
  # @return [Game] - the game object
  def self.check_game_mode(game_mode, config = GameConfig.new)
    case game_mode.to_i
    when 1
      # Human vs Human
      Game.new(HumanPlayer.new(true), HumanPlayer.new(false), config)
    when 2
      # Computer vs Human
      Game.new(ComputerPlayer.new, HumanPlayer.new(false), config)
    when 3
      # Computer vs Computer
      Game.new(ComputerPlayer.new, ComputerPlayer.new, config)
    end
  end
end
