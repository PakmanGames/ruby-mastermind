require_relative 'player'
require_relative 'secret_code'
require_relative 'board'
require_relative 'pins'
require 'pry-byebug'

class Game
  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = nil
    @current_guess = Code.new([], [])
    @board = Board.new(secret_code)
  end
  attr_reader :code_maker, :code_breaker
  attr_accessor :secret_code, :current_guess, :board

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
    play_round until board.check_winner
  end

  def play_round
    # binding.pry
    puts "\n#{code_breaker.name} guess what the secret code might be: "
    current_guess = SecretCode.enter_code
    pins = Pins.generate_pins(secret_code, current_guess)
    puts "\n#{current_guess} #{Pins.display(pins)}"
    board.current_pins = pins[:pins]
  end

  def self.choose_game
    puts 'welcome to mastermind'
    puts 'Which type of game do you want to play?'
    puts '(Note that the first player will always be the codemaker)'
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
      Game.new(Player.new(true, true), Player.new(true, false))
    when 2
      Game.new(Player.new(false, true), Player.new(true, false))
    when 3
      # computer vs computer
    end
  end
end
