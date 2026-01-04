# frozen_string_literal: true

require 'spec_helper'
require 'stringio'
require_relative '../../lib/mastermind/game'
require_relative '../../lib/mastermind/player'
require_relative '../../lib/mastermind/secret_code'
require_relative '../../lib/mastermind/board'
require_relative '../../lib/mastermind/pins'
require_relative '../../lib/mastermind/code'
require_relative '../../lib/mastermind/game_display'

RSpec.describe Game do
  describe '#initialize' do
    it 'creates a game with code_maker and code_breaker' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')

      game = Game.new(code_maker, code_breaker)

      expect(game.code_maker).to eq(code_maker)
      expect(game.code_breaker).to eq(code_breaker)
    end

    it 'initializes secret_code as nil' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')

      game = Game.new(code_maker, code_breaker)

      expect(game.secret_code).to be_nil
    end

    it 'initializes current_guess as empty Code' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')

      game = Game.new(code_maker, code_breaker)

      expect(game.current_guess).to be_a(Code)
      expect(game.current_guess.code_data[:colors]).to eq([])
    end

    it 'initializes board' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')

      game = Game.new(code_maker, code_breaker)

      expect(game.board).to be_a(Board)
    end

    it 'initializes turn as 0' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')

      game = Game.new(code_maker, code_breaker)

      expect(game.turn).to eq(0)
    end
  end

  describe '#setup_secret_code' do
    context 'when code_maker is human' do
      it 'calls setup_human_secret_code' do
        code_maker = instance_double('Player', human: true)
        code_breaker = instance_double('Player')
        game = Game.new(code_maker, code_breaker)

        allow(game).to receive(:setup_human_secret_code)
        allow($stdout).to receive(:puts)
        allow(game).to receive(:sleep)

        game.setup_secret_code

        expect(game).to have_received(:setup_human_secret_code)
      end
    end

    context 'when code_maker is computer' do
      it 'calls setup_computer_secret_code' do
        code_maker = instance_double('Player', human: false)
        code_breaker = instance_double('Player')
        game = Game.new(code_maker, code_breaker)

        allow(game).to receive(:setup_computer_secret_code)
        allow($stdout).to receive(:puts)
        allow(game).to receive(:sleep)

        game.setup_secret_code

        expect(game).to have_received(:setup_computer_secret_code)
      end
    end

    it 'displays code generated message' do
      code_maker = instance_double('Player', human: false)
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      allow(game).to receive(:setup_computer_secret_code)
      allow(game).to receive(:sleep)
      expect($stdout).to receive(:puts).with("Code generated! Now let's play!")

      game.setup_secret_code
    end
  end

  describe '#setup_human_secret_code' do
    it 'prompts code_maker to create secret code' do
      code_maker = instance_double('Player', name: 'Alice', human: true)
      code_breaker = instance_double('Player', name: 'Bob')
      game = Game.new(code_maker, code_breaker)

      allow(SecretCode).to receive(:enter_code).and_return(instance_double('Code'))
      allow($stdout).to receive(:puts)

      game.setup_human_secret_code

      expect(SecretCode).to have_received(:enter_code)
    end

    it 'sets secret_code from SecretCode.enter_code' do
      code_maker = instance_double('Player', name: 'Alice', human: true)
      code_breaker = instance_double('Player', name: 'Bob')
      game = Game.new(code_maker, code_breaker)

      secret_code = instance_double('Code')
      allow(SecretCode).to receive(:enter_code).and_return(secret_code)
      allow($stdout).to receive(:puts)

      game.setup_human_secret_code

      expect(game.secret_code).to eq(secret_code)
    end
  end

  describe '#setup_computer_secret_code' do
    it 'generates secret code using SecretCode.generate_secret_code' do
      code_maker = instance_double('Player', human: false)
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      secret_code = instance_double('Code')
      allow(SecretCode).to receive(:generate_secret_code).and_return(secret_code)

      game.setup_computer_secret_code

      expect(game.secret_code).to eq(secret_code)
    end

  end

  describe '#play_rounds_until_complete' do
    it 'plays rounds until winner is found' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      # Stub Kernel.puts to prevent blocking from puts calls
      allow(Kernel).to receive(:puts)

      allow(game.board).to receive(:check_winner).and_return(false, false, true)
      allow(game).to receive(:play_round)

      game.play_rounds_until_complete

      expect(game).to have_received(:play_round).twice
    end

    it 'stops when turn reaches 12' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)
      game.turn = 11

      allow(Kernel).to receive(:puts)

      allow(game.board).to receive(:check_winner).and_return(false)
      allow(game).to receive(:play_round) { game.turn += 1 }

      game.play_rounds_until_complete

      expect(game.turn).to eq(12)
    end
  end

  describe '#display_game_result' do
    it 'displays win message when board.check_winner is true' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player', name: 'Alice')
      game = Game.new(code_maker, code_breaker)
      game.turn = 5

      allow(Kernel).to receive(:puts)

      allow(game.board).to receive(:check_winner).and_return(true)

      expect(GameDisplay).to receive(:win_message).with(code_breaker, 5)

      game.display_game_result
    end

    it 'displays loss message when turn is 12 and no winner' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)
      game.turn = 12
      secret_code = instance_double('Code')
      game.secret_code = secret_code

      allow(game.board).to receive(:check_winner).and_return(false)
      allow(GameDisplay).to receive(:loss_message)

      game.display_game_result

      expect(GameDisplay).to have_received(:loss_message).with(secret_code)
    end
  end

  describe '#play_round' do
    it 'increments turn and displays round header' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player', name: 'Alice')
      game = Game.new(code_maker, code_breaker)

      allow(game).to receive(:increment_turn_and_display)
      allow(game).to receive(:code_breaker_guess).and_return(instance_double('Code'))
      allow(game).to receive(:generate_pins_for_guess).and_return({ pins: [] })
      allow(game).to receive(:process_and_display_results)

      game.play_round

      expect(game).to have_received(:increment_turn_and_display)
    end

    it 'gets code breaker guess' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code')
      allow(game).to receive(:increment_turn_and_display)
      allow(game).to receive(:code_breaker_guess).and_return(guess)
      allow(game).to receive(:generate_pins_for_guess).and_return({ pins: [] })
      allow(game).to receive(:process_and_display_results)

      game.play_round

      expect(game).to have_received(:code_breaker_guess)
    end

    it 'generates pins for the guess' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code')
      allow(game).to receive(:increment_turn_and_display)
      allow(game).to receive(:code_breaker_guess).and_return(guess)
      allow(game).to receive(:generate_pins_for_guess).and_return({ pins: [] })
      allow(game).to receive(:process_and_display_results)

      game.play_round

      expect(game).to have_received(:generate_pins_for_guess).with(guess)
    end

    it 'processes and displays results' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code')
      pins = { pins: %i[red white] }
      allow(game).to receive(:increment_turn_and_display)
      allow(game).to receive(:code_breaker_guess).and_return(guess)
      allow(game).to receive(:generate_pins_for_guess).and_return(pins)
      allow(game).to receive(:process_and_display_results)

      game.play_round

      expect(game).to have_received(:process_and_display_results).with(guess, pins)
    end
  end

  describe '#increment_turn_and_display' do
    it 'increments turn by 1' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player', name: 'Alice')
      game = Game.new(code_maker, code_breaker)
      initial_turn = game.turn

      allow(GameDisplay).to receive(:round_header)

      game.increment_turn_and_display

      expect(game.turn).to eq(initial_turn + 1)
    end

    it 'displays round header' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player', name: 'Alice')
      game = Game.new(code_maker, code_breaker)

      allow(GameDisplay).to receive(:round_header)

      game.increment_turn_and_display

      expect(GameDisplay).to have_received(:round_header).with(1, code_breaker)
    end
  end

  describe '#code_breaker_guess' do
    it 'calls SecretCode.enter_code' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code')
      allow(SecretCode).to receive(:enter_code).and_return(guess)

      result = game.code_breaker_guess

      expect(result).to eq(guess)
      expect(SecretCode).to have_received(:enter_code)
    end
  end

  describe '#generate_pins_for_guess' do
    it 'calls Pins.generate_pins with secret_code and guess' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      secret_code = instance_double('Code')
      guess = instance_double('Code')
      game.secret_code = secret_code
      pins = { pins: [:red] }

      allow(Pins).to receive(:generate_pins).and_return(pins)

      result = game.generate_pins_for_guess(guess)

      expect(result).to eq(pins)
      expect(Pins).to have_received(:generate_pins).with(secret_code, guess)
    end
  end

  describe '#process_and_display_results' do
    it 'formats guess results and appends to board moves' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code', to_s: '| red | green | blue | yellow |')
      pins = { pins: [:red], rainbow_pins: ['red'] }

      allow(game).to receive(:format_guess_results).and_return('formatted result')
      allow(GameDisplay).to receive(:board)

      game.process_and_display_results(guess, pins)

      expect(game.board.moves).to include('formatted result')
    end

    it 'displays the board' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code')
      pins = { pins: [:red] }

      allow(game).to receive(:format_guess_results).and_return('formatted result')
      allow(GameDisplay).to receive(:board)

      game.process_and_display_results(guess, pins)

      expect(GameDisplay).to have_received(:board).with(game.board)
    end

    it 'sets board current_pins' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code')
      pins = { pins: %i[red white] }

      allow(game).to receive(:format_guess_results).and_return('formatted result')
      allow(GameDisplay).to receive(:board)

      game.process_and_display_results(guess, pins)

      expect(game.board.current_pins).to eq(%i[red white])
    end
  end

  describe '#format_guess_results' do
    it 'formats guess and pins together' do
      code_maker = instance_double('Player')
      code_breaker = instance_double('Player')
      game = Game.new(code_maker, code_breaker)

      guess = instance_double('Code', to_s: '| red | green | blue | yellow |')
      pins = { pins: [:red], rainbow_pins: ['red'] }

      allow(Pins).to receive(:display).and_return('-red-')

      result = game.format_guess_results(guess, pins)

      expect(result).to include('| red | green | blue | yellow |')
      expect(result).to include('-red-')
    end
  end

  describe '.choose_game' do
    it 'displays welcome message' do
      allow(GameDisplay).to receive(:welcome_message)
      allow(Game).to receive(:collect_game_mode_choice).and_return('1')
      allow(Game).to receive(:check_game_mode).and_return(instance_double('Game'))

      Game.choose_game

      expect(GameDisplay).to have_received(:welcome_message)
    end

    it 'collects game mode choice' do
      allow(GameDisplay).to receive(:welcome_message)
      allow(Game).to receive(:collect_game_mode_choice).and_return('1')
      allow(Game).to receive(:check_game_mode).and_return(instance_double('Game'))

      Game.choose_game

      expect(Game).to have_received(:collect_game_mode_choice)
    end

    it 'checks game mode and returns game' do
      game = instance_double('Game')
      allow(GameDisplay).to receive(:welcome_message)
      allow(Game).to receive(:collect_game_mode_choice).and_return('1')
      allow(Game).to receive(:check_game_mode).and_return(game)

      result = Game.choose_game

      expect(result).to eq(game)
      expect(Game).to have_received(:check_game_mode).with('1')
    end
  end

  describe '.collect_game_mode_choice' do
    it 'prompts for game mode until valid choice' do
      allow_any_instance_of(Object).to receive(:gets).and_return("invalid\n", "4\n", "1\n")
      allow($stdout).to receive(:puts)

      result = Game.collect_game_mode_choice

      expect(result).to eq('1')
    end

    it 'accepts valid game mode choices' do
      allow_any_instance_of(Object).to receive(:gets).and_return("2\n")
      allow($stdout).to receive(:puts)

      result = Game.collect_game_mode_choice

      expect(result).to eq('2')
    end

    it 'displays game mode options' do
      allow_any_instance_of(Object).to receive(:gets).and_return("1\n")
      expect($stdout).to receive(:puts).with("(1) Human vs Human\n(2) Computer vs Human\n(3) Computer vs Computer")

      Game.collect_game_mode_choice
    end
  end

  describe '.check_game_mode' do
    it 'creates Human vs Human game for mode 1' do
      allow(Player).to receive(:new).and_return(instance_double('Player'))

      game = Game.check_game_mode('1')

      expect(game).to be_a(Game)
      expect(Player).to have_received(:new).with(true, true).once
      expect(Player).to have_received(:new).with(true, false).once
    end

    it 'creates Computer vs Human game for mode 2' do
      allow(Player).to receive(:new).and_return(instance_double('Player'))

      game = Game.check_game_mode('2')

      expect(game).to be_a(Game)
      expect(Player).to have_received(:new).with(false, true).once
      expect(Player).to have_received(:new).with(true, false).once
    end

    it 'creates Computer vs Computer game for mode 3' do
      allow(Player).to receive(:new).and_return(instance_double('Player'))
      allow($stdout).to receive(:puts)

      game = Game.check_game_mode('3')

      expect(game).to be_a(Game)
      expect(Player).to have_received(:new).with(false, true).once
      expect(Player).to have_received(:new).with(false, false).once
    end

    it 'displays work in progress message for mode 3' do
      allow(Player).to receive(:new).and_return(instance_double('Player'))
      expect($stdout).to receive(:puts).with('Work in progress')

      Game.check_game_mode('3')
    end
  end
end
