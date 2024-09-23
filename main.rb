# frozen_string_literal: true

require_relative 'lib/game'

# Create a new instance of Game and then #play_game
game = Game.choose_game
game.play_game
