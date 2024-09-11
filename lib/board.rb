class Board
  def initialize(secret_code)
    @secret_code = secret_code
    @moves = []
    @current_pins = Array.new(4)
  end
  attr_accessor :secret_code, :moves, :current_pins

  def check_winner
    current_pins.all? { |pin| pin == :red }
  end
end
