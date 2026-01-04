# frozen_string_literal: true

require 'spec_helper'
require 'stringio'
require_relative '../../lib/mastermind/game_display'
require_relative '../../lib/mastermind/player'
require_relative '../../lib/mastermind/board'
require_relative '../../lib/mastermind/code'
require_relative '../../lib/mastermind/secret_code'

RSpec.describe GameDisplay do
  describe '.player_matchup' do
    it 'outputs player matchup to stdout' do
      code_maker = instance_double('Player', name: 'Alice')
      code_breaker = instance_double('Player', name: 'Bob')

      expect { GameDisplay.player_matchup(code_maker, code_breaker) }.to output.to_stdout
    end

    it 'displays code maker and code breaker names' do
      code_maker = instance_double('Player', name: 'Alice')
      code_breaker = instance_double('Player', name: 'Bob')

      expect { GameDisplay.player_matchup(code_maker, code_breaker) }.to output(/Alice.*Code Maker.*Bob.*Code Breaker/).to_stdout
    end

    it 'handles computer players' do
      code_maker = instance_double('Player', name: 'Computer')
      code_breaker = instance_double('Player', name: 'Computer')

      expect { GameDisplay.player_matchup(code_maker, code_breaker) }.to output(/Computer/).to_stdout
    end
  end

  describe '.win_message' do
    it 'outputs win message to stdout' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 5

      expect { GameDisplay.win_message(code_breaker, turn) }.to output.to_stdout
    end

    it 'displays congratulations message' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 5

      expect { GameDisplay.win_message(code_breaker, turn) }.to output(/CODE HAS BEEN BROKEN/).to_stdout
    end

    it 'includes player name and turn count' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 5

      expect { GameDisplay.win_message(code_breaker, turn) }.to output(/Alice.*5 rounds/).to_stdout
    end

    it 'handles single turn' do
      code_breaker = instance_double('Player', name: 'Bob')
      turn = 1

      expect { GameDisplay.win_message(code_breaker, turn) }.to output(/1 rounds/).to_stdout
    end
  end

  describe '.loss_message' do
    it 'outputs loss message to stdout' do
      secret_code = instance_double('SecretCode', to_s: '| red | green | blue | yellow |')

      expect { GameDisplay.loss_message(secret_code) }.to output.to_stdout
    end

    it 'displays loss message' do
      secret_code = instance_double('SecretCode', to_s: '| red | green | blue | yellow |')

      expect { GameDisplay.loss_message(secret_code) }.to output(/YOU LOSE/).to_stdout
    end

    it 'displays the secret code' do
      secret_code = instance_double('SecretCode', to_s: '| red | green | blue | yellow |')

      expect { GameDisplay.loss_message(secret_code) }.to output(/The secret code was/).to_stdout
    end

    it 'calls to_s on secret_code' do
      secret_code = instance_double('SecretCode', to_s: '| red | green | blue | yellow |')

      expect(secret_code).to receive(:to_s)

      GameDisplay.loss_message(secret_code)
    end
  end

  describe '.board' do
    it 'outputs board to stdout' do
      board = instance_double('Board', moves: %w[move1 move2])

      expect { GameDisplay.board(board) }.to output.to_stdout
    end

    it 'displays all moves' do
      board = instance_double('Board', moves: %w[move1 move2 move3])

      expect { GameDisplay.board(board) }
        .to output(/move1.*move2.*move3/m).to_stdout
    end

    it 'handles empty moves' do
      board = instance_double('Board', moves: [])

      expect { GameDisplay.board(board) }.not_to output.to_stdout
    end

    it 'displays each move on a new line' do
      board = instance_double('Board', moves: %w[move1 move2])

      output = capture_output { GameDisplay.board(board) }

      expect(output.split("\n").length).to eq(4)
    end
  end

  describe '.round_header' do
    it 'outputs round header to stdout' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 3

      expect { GameDisplay.round_header(turn, code_breaker) }.to output.to_stdout
    end

    it 'displays round number' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 3

      expect { GameDisplay.round_header(turn, code_breaker) }.to output(/ROUND 3/).to_stdout
    end

    it 'displays code breaker name' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 3

      expect { GameDisplay.round_header(turn, code_breaker) }.to output(/Alice/).to_stdout
    end

    it 'prompts for guess' do
      code_breaker = instance_double('Player', name: 'Alice')
      turn = 3

      expect { GameDisplay.round_header(turn, code_breaker) }.to output(/guess what the secret code might be/).to_stdout
    end
  end

  describe '.welcome_message' do
    it 'outputs welcome message to stdout' do
      expect { GameDisplay.welcome_message }.to output.to_stdout
    end

    it 'displays welcome text' do
      expect { GameDisplay.welcome_message }
        .to output(/Welcome to Mastermind/).to_stdout
    end

    it 'displays game rules' do
      expect { GameDisplay.welcome_message }
        .to output(/12 turns to break a code/).to_stdout
    end

    it 'displays game type options' do
      expect { GameDisplay.welcome_message }
        .to output(/Which type of game do you want to play/).to_stdout
    end

    it 'displays note about first player' do
      expect { GameDisplay.welcome_message }
        .to output(/first player will always be the code maker/).to_stdout
    end

    it 'prompts for game type selection' do
      expect { GameDisplay.welcome_message }
        .to output(/Type the corresponding number/).to_stdout
    end
  end

  # Helper method to capture output for testing
  def capture_output
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
