require_relative 'player'
require_relative 'secret_code'

class Game
  attr_reader :code_maker, :code_breaker
  attr_accessor :secret_code

  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
    @secret_code = nil
  end

  def play_game
    puts "#{code_maker.name} (Code Maker) vs #{code_breaker.name} (Code Breaker)"

    if code_maker.human
      puts "#{code_maker.name} create a secret code that #{code_breaker.name} will try to guess."
      secret_code = SecretCode.enter_code
    elsif !code_maker.human
      secret_code = SecretCode.generate_secret_code
    end

    # temperary for testing
    puts secret_code

    # play round logic
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
