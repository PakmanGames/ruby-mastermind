# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/board'
require_relative '../../lib/mastermind/code'

RSpec.describe Board do
  describe '#initialize' do
    it 'creates a board with secret_code' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)

      expect(board.secret_code).to eq(secret_code)
    end

    it 'initializes moves as an empty array' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)

      expect(board.moves).to eq([])
    end

    it 'initializes current_pins as an array of 4 nil values' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)

      expect(board.current_pins).to eq([nil, nil, nil, nil])
      expect(board.current_pins.length).to eq(4)
    end
  end

  describe '#check_winner' do
    it 'returns true when all pins are red and length is 4' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      board.current_pins = %i[red red red red]

      expect(board.check_winner).to be true
    end

    it 'returns false when not all pins are red' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      board.current_pins = %i[red red white red]

      expect(board.check_winner).to be false
    end

    it 'returns false when length is not 4' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      board.current_pins = %i[red red red]

      expect(board.check_winner).to be false
    end

    it 'returns false when current_pins contains nil values' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      board.current_pins = [nil, nil, nil, nil]

      expect(board.check_winner).to be false
    end

    it 'returns false when current_pins is empty' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      board.current_pins = []

      expect(board.check_winner).to be false
    end
  end

  describe 'attributes' do
    # TODO: Note maybe we shouldn't be able to set the secret_code?
    it 'allows setting and getting secret_code' do
      secret_code1 = instance_double('Code')
      secret_code2 = instance_double('Code')
      board = Board.new(secret_code1)

      board.secret_code = secret_code2

      expect(board.secret_code).to eq(secret_code2)
    end

    it 'allows setting and getting moves' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      moves = %w[move1 move2]

      board.moves = moves

      expect(board.moves).to eq(moves)
    end

    it 'allows appending to moves' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)

      board.moves.append('move1')

      expect(board.moves).to include('move1')
    end

    it 'allows setting and getting current_pins' do
      secret_code = instance_double('Code')
      board = Board.new(secret_code)
      pins = %i[red white red white]

      board.current_pins = pins

      expect(board.current_pins).to eq(pins)
    end
  end
end
