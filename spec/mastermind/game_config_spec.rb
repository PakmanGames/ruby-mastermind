# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/game_config'

RSpec.describe GameConfig do
  describe '#initialize' do
    it 'defaults to a code length of 4 and 12 turns' do
      config = GameConfig.new

      expect(config.code_length).to eq(4)
      expect(config.turn_limit).to eq(12)
    end

    it 'stores the provided code length and turn limit' do
      config = GameConfig.new(code_length: 6, turn_limit: 10)

      expect(config.code_length).to eq(6)
      expect(config.turn_limit).to eq(10)
    end

    it 'accepts the boundary values' do
      expect { GameConfig.new(code_length: GameConfig::MIN_CODE_LENGTH, turn_limit: GameConfig::MIN_TURN_LIMIT) }
        .not_to raise_error
      expect { GameConfig.new(code_length: GameConfig::MAX_CODE_LENGTH, turn_limit: GameConfig::MAX_TURN_LIMIT) }
        .not_to raise_error
    end

    it 'rejects a code length below the minimum' do
      expect { GameConfig.new(code_length: GameConfig::MIN_CODE_LENGTH - 1) }
        .to raise_error(ArgumentError, /Code length/)
    end

    it 'rejects a code length above the maximum' do
      expect { GameConfig.new(code_length: GameConfig::MAX_CODE_LENGTH + 1) }
        .to raise_error(ArgumentError, /Code length/)
    end

    it 'rejects a turn limit below the minimum' do
      expect { GameConfig.new(turn_limit: GameConfig::MIN_TURN_LIMIT - 1) }
        .to raise_error(ArgumentError, /Turn limit/)
    end

    it 'rejects a turn limit above the maximum' do
      expect { GameConfig.new(turn_limit: GameConfig::MAX_TURN_LIMIT + 1) }
        .to raise_error(ArgumentError, /Turn limit/)
    end

    it 'rejects a non-integer code length' do
      expect { GameConfig.new(code_length: 4.5) }.to raise_error(ArgumentError)
    end
  end

  describe 'bounds' do
    it 'keeps the minimum code length at or above the maximum turn requirement floor' do
      expect(GameConfig::MIN_CODE_LENGTH).to eq(4)
      expect(GameConfig::MAX_CODE_LENGTH).to eq(8)
      expect(GameConfig::MIN_TURN_LIMIT).to eq(8)
      expect(GameConfig::MAX_TURN_LIMIT).to eq(14)
    end
  end

  describe '.suggested_min_turns' do
    it 'scales the suggestion with the code length' do
      expect(GameConfig.suggested_min_turns(4)).to eq(8)
      expect(GameConfig.suggested_min_turns(6)).to eq(10)
    end

    it 'never suggests fewer than the minimum turn limit' do
      expect(GameConfig.suggested_min_turns(GameConfig::MIN_CODE_LENGTH))
        .to be >= GameConfig::MIN_TURN_LIMIT
    end

    it 'never suggests more than the maximum turn limit' do
      expect(GameConfig.suggested_min_turns(GameConfig::MAX_CODE_LENGTH))
        .to be <= GameConfig::MAX_TURN_LIMIT
    end
  end

  describe '.collect' do
    it 'builds a GameConfig from the collected code length and turn limit' do
      allow(GameConfig).to receive(:collect_code_length).and_return(6)
      allow(GameConfig).to receive(:collect_turn_limit).with(6).and_return(11)

      config = GameConfig.collect

      expect(config).to be_a(GameConfig)
      expect(config.code_length).to eq(6)
      expect(config.turn_limit).to eq(11)
    end
  end

  describe '.collect_code_length' do
    it 'prompts within the code-length bounds' do
      allow(GameConfig).to receive(:prompt_in_range).and_return(5)

      expect(GameConfig.collect_code_length).to eq(5)
      expect(GameConfig).to have_received(:prompt_in_range)
        .with(anything, GameConfig::MIN_CODE_LENGTH, GameConfig::MAX_CODE_LENGTH)
    end
  end

  describe '.collect_turn_limit' do
    it 'shows the suggested minimum and prompts within the turn bounds' do
      allow($stdout).to receive(:puts)
      allow(GameConfig).to receive(:prompt_in_range).and_return(10)

      result = GameConfig.collect_turn_limit(6)

      expect(result).to eq(10)
      expect(GameConfig).to have_received(:prompt_in_range)
        .with(anything, GameConfig::MIN_TURN_LIMIT, GameConfig::MAX_TURN_LIMIT)
      expect($stdout).to have_received(:puts).with(/suggest at least 10 turns/)
    end
  end

  describe '.prompt_in_range' do
    it 'returns the first in-range integer entered' do
      allow_any_instance_of(Object).to receive(:gets).and_return("5\n")
      allow($stdout).to receive(:puts)

      expect(GameConfig.prompt_in_range('Question?', 4, 8)).to eq(5)
    end

    it 're-prompts until the value is within range' do
      allow_any_instance_of(Object).to receive(:gets).and_return("2\n", "99\n", "6\n")
      allow($stdout).to receive(:puts)

      expect(GameConfig.prompt_in_range('Question?', 4, 8)).to eq(6)
    end

    it 'falls back to the minimum on end of input rather than looping forever' do
      allow_any_instance_of(Object).to receive(:gets).and_return(nil)
      allow($stdout).to receive(:puts)

      expect(GameConfig.prompt_in_range('Question?', 4, 8)).to eq(4)
    end
  end
end
