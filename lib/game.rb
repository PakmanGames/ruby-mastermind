require_relative 'player'

class Game
  attr_reader :code_maker, :code_breaker

  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
  end

  def play_game
    puts "#{code_maker.name} (Code Maker) vs #{code_breaker.name} (Code Breaker)"
    nil unless code_maker.human
    # logic to make secret code

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
      # human vs human
    when 2
      # computer vs human
      Game.new(Player.new(false), Player.new(true))
    when 3
      # computer vs computer
    end
  end
end
