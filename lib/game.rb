require_relative 'player'
require_relative 'secret_code'
require_relative 'board'
require_relative 'pins'

class Game
  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = nil
    @current_guess = Code.new([], [])
    @board = Board.new(secret_code)
    @turn = 0
  end
  attr_reader :code_maker, :code_breaker
  attr_accessor :secret_code, :current_guess, :board, :turn

  def play_game
    puts "#{code_maker.name} (Code Maker) vs #{code_breaker.name} (Code Breaker)"

    if code_maker.human
      puts "#{code_maker.name} create a secret code that #{code_breaker.name} will try to guess."
      puts "Make sure you remember the code, you won't be able to see it again!"
      @secret_code = SecretCode.enter_code
      puts "\n" * 100
    elsif !code_maker.human
      @secret_code = SecretCode.generate_secret_code
      board.secret_code = @secret_code
    end

    # temperary for testing
    puts secret_code

    puts "Code generated! Now let's play!"
    sleep(1)

    # play round logic
    play_round until board.check_winner || turn == 12
    if board.check_winner
      puts "\nCODE HAS BEEN BROKEN!!"
      puts "Congratulations #{code_breaker.name} you successfully broke the code!"
    elsif turn == 12
      puts "\nUnfortunately, it looks like you weren't able to break the code :("
      puts 'YOU LOSE!'
      puts "The secret code was: #{secret_code}"
    end
  end

  def play_round
    @turn += 1
    puts "\nROUND #{turn}"
    puts "#{code_breaker.name} guess what the secret code might be: "
    current_guess = SecretCode.enter_code
    pins = Pins.generate_pins(secret_code, current_guess)
    results = "#{current_guess} #{Pins.display(pins)}"
    board.moves.append(results)
    board.moves.each { |move| puts "\n#{move}" }
    board.current_pins = pins[:pins]
  end

  def self.choose_game
    puts 'Welcome to Mastermind!'
    puts 'The code breaker has 12 turns to break a code the code maker creates.'
    puts 'Which type of game do you want to play?'
    puts '(Note that the first player will always be the code maker)'
    puts 'Type the corresponding number to choose a game type: '
    gamemode = String.new
    until [1, 2, 3].include?(gamemode.to_i)
      puts "(1) Human vs Human\n(2) Computer vs Human\n(3) Computer vs Computer"
      gamemode = gets.chomp
    end
    check_gamemode(gamemode)
  end

  def self.check_gamemode(gamemode)
    case gamemode.to_i
    when 1
      # human vs human
      Game.new(Player.new(true, true), Player.new(true, false))
    when 2
      # computer vs human
      Game.new(Player.new(false, true), Player.new(true, false))
    when 3
      # human vs computer
      Game.new(Plauer.new(true, true), Player.new(false, false))
    when 4
      # computer vs computer
      Game.new(Player.new(false, true), Player.new(false, false))
    end
  end
end
