class Player
  attr_reader :name, :human

  def initialize(human, code_maker)
    @name = 'Computer'
    @human = human
    return unless human

    puts "What's your name? #{code_maker ? '(Code Maker)' : '(Code Breaker)'}"
    @name = gets.chomp
  end
end
