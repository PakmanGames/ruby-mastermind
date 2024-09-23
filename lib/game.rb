# frozen_string_literal: true

require_relative 'player'
require_relative 'secret_code'
require_relative 'board'
require_relative 'pins'

##
# This class represents the main mastermind game.
# It contains all the game logic and rules.
class Game
  attr_reader :code_maker, :code_breaker
  attr_accessor :secret_code, :current_guess, :board, :turn

  ##
  # Create new instance of Game class,
  # described by +code_maker and +code_breaker which
  # are instances of the player class
  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = nil
    @current_guess = Code.new([], [])
    @board = Board.new(secret_code)
    @turn = 0 # To keep track of the rounds
  end

  # Main game logic
  #
  # @return [Nil]
  def play_game
    puts "#{code_maker.name} (Code Maker) vs #{code_breaker.name} (Code Breaker)"

    if code_maker.human
      # Creates a secret code if the code maker is a human player
      puts "\n#{code_maker.name} create a secret code that #{code_breaker.name} will try to guess."
      puts "Make sure you remember the code, you won't be able to see it again!"
      @secret_code = SecretCode.enter_code
      puts "\n" * 100 # Clear console so code breaker can't cheat
    elsif !code_maker.human
      # Otherwise, generate random secret code
      @secret_code = SecretCode.generate_secret_code
      board.secret_code = @secret_code
    end

    puts "Code generated! Now let's play!"
    sleep(1)

    # Play round logic
    play_round until board.check_winner || turn == 12
    if board.check_winner
      # Winning output
      puts "\nCODE HAS BEEN BROKEN!!"
      puts "Congratulations #{code_breaker.name} you successfully broke the code in #{turn} rounds!"
    elsif turn == 12
      # Losing output :(
      puts "\nUnfortunately, it looks like you weren't able to break the code :("
      puts 'YOU LOSE!'
      puts "The secret code was: #{secret_code}"
    end
  end

  # Plays a round of mastermind
  #
  # @return [Nil]
  def play_round
    @turn += 1
    puts "\nROUND #{turn}"
    puts "#{code_breaker.name} guess what the secret code might be: "
    current_guess = SecretCode.enter_code # Get guess from code breaker
    pins = Pins.generate_pins(secret_code, current_guess) # Create pins based on guess
    results = "#{current_guess} #{Pins.display(pins)}"
    board.moves.append(results)
    board.moves.each { |move| puts "\n#{move}" } # Display entire board (includes previous guesses and pins)
    board.current_pins = pins[:pins]
  end

  # Sets the gamemode
  #
  # @return [Game Object] to be used as the mastermind game
  def self.choose_game
    # Display welcome message and rules
    puts 'Welcome to Mastermind!'
    puts 'The code breaker has 12 turns to break a code the code maker creates.'
    puts 'Which type of game do you want to play?'
    puts '(Note that the first player will always be the code maker)'
    puts 'Type the corresponding number to choose a game type: '
    gamemode = String.new
    # Loop until user enters a valid gamemode
    until [1, 2, 3].include?(gamemode.to_i)
      puts "(1) Human vs Human\n(2) Computer vs Human\n(3) Computer vs Computer"
      gamemode = gets.chomp
    end
    check_gamemode(gamemode)
  end

  # Creates the game based on the selected gamemode
  #
  # @param [String] represents the chosen gamemode
  # @return [Game Object] to represent the mastermind game
  def self.check_gamemode(gamemode)
    case gamemode.to_i # Change to integer
    when 1
      # Human vs Human
      Game.new(Player.new(true, true), Player.new(true, false))
    when 2
      # Computer vs Human
      Game.new(Player.new(false, true), Player.new(true, false))
    when 3
      # TODO: human vs computer
      puts 'Work in progress'
      Game.new(Plauer.new(true, true), Player.new(false, false))
    when 4
      # TODO: computer vs computer
      puts 'Work in progress'
      Game.new(Player.new(false, true), Player.new(false, false))
    end
  end
end
