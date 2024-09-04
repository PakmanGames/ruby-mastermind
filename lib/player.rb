class Player
  attr_reader :name, :human

  def initialize(human)
    @name = 'Computer'
    @human = human
    return unless human

    puts "What's your name?"
    @name = gets.chomp
  end
end
