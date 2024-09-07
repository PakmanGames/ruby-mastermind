require 'rainbow'

module Pins
  def self.generate_pins(secret_code, guess)
    pins = []
    guess.code_data[:colors].each_with_index do |color, index|
      if color == secret_code.code_data.dig(:colors, index)
        pins.push(:red)
      elsif secret_code.code_data[:colors].include?(color)
        pins.push(:silver)
      end
    end
    rainbow_pins = colorize(pins)
    {
      pins: pins,
      rainbow_pins: rainbow_pins
    }
  end

  def self.colorize(colors)
    colors.map { |color| Rainbow(color).color(color).bg(:black).bright }
  end

  def self.display(pins)
    pins[:rainbow_pins].inject('-') { |acc, curr| "#{acc + curr}-" }
  end
end
