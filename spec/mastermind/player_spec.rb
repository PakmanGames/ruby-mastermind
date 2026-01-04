# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/player'

RSpec.describe Player do
  describe '#initialize' do
    context 'when player is human' do
      it 'prompts for name and sets it' do
        allow_any_instance_of(Object).to receive(:gets).and_return("Alice\n")
        allow($stdout).to receive(:puts)

        player = Player.new(true, true)

        expect(player.name).to eq('Alice')
        expect(player.human).to be true
      end

      it 'handles code maker role' do
        allow_any_instance_of(Object).to receive(:gets).and_return("Bob\n")
        allow($stdout).to receive(:puts)

        player = Player.new(true, true)

        expect(player.name).to eq('Bob')
      end

      it 'handles code breaker role' do
        allow_any_instance_of(Object).to receive(:gets).and_return("Charlie\n")
        allow($stdout).to receive(:puts)

        player = Player.new(true, false)

        expect(player.name).to eq('Charlie')
      end

      it 'trims whitespace from name' do
        allow_any_instance_of(Object).to receive(:gets).and_return("  David  \n")
        allow($stdout).to receive(:puts)

        player = Player.new(true, true)

        expect(player.name).to eq('David')
      end
    end

    context 'when player is computer' do
      it 'sets name to "Computer" without prompting' do
        player = Player.new(false, true)

        expect(player.name).to eq('Computer')
        expect(player.human).to be false
      end

      it 'does not call gets' do
        expect($stdin).not_to receive(:gets)

        Player.new(false, true)
      end

      it 'works for code maker role' do
        player = Player.new(false, true)

        expect(player.name).to eq('Computer')
        expect(player.human).to be false
      end

      it 'works for code breaker role' do
        player = Player.new(false, false)

        expect(player.name).to eq('Computer')
        expect(player.human).to be false
      end
    end
  end

  describe '#prompt_for_name' do
    context 'when player is code maker' do
      it 'prompts with code maker role indicator' do
        player = Player.new(false, true)
        allow_any_instance_of(Object).to receive(:gets).and_return("Alice\n")
        allow($stdout).to receive(:puts)

        player.send(:prompt_for_name)

        expect($stdout).to have_received(:puts).with("What's your name? (Code Maker)")
      end

      it 'returns the trimmed name' do
        player = Player.new(false, true)
        allow_any_instance_of(Object).to receive(:gets).and_return("  Bob  \n")
        allow($stdout).to receive(:puts)

        result = player.send(:prompt_for_name)

        expect(result).to eq('Bob')
      end
    end

    context 'when player is code breaker' do
      it 'prompts with code breaker role indicator' do
        player = Player.new(false, false)
        allow_any_instance_of(Object).to receive(:gets).and_return("Charlie\n")
        allow($stdout).to receive(:puts)

        player.send(:prompt_for_name)

        expect($stdout).to have_received(:puts).with("What's your name? (Code Breaker)")
      end

      it 'returns the trimmed name' do
        player = Player.new(false, false)
        allow_any_instance_of(Object).to receive(:gets).and_return("David\n")
        allow($stdout).to receive(:puts)

        result = player.send(:prompt_for_name)

        expect(result).to eq('David')
      end
    end

    it 'reads input from gets' do
      player = Player.new(false, true)
      allow($stdout).to receive(:puts)
      expect_any_instance_of(Object).to receive(:gets).and_return("Eve\n")

      player.send(:prompt_for_name)
    end

    it 'handles names with leading and trailing whitespace' do
      player = Player.new(false, true)
      allow_any_instance_of(Object).to receive(:gets).and_return("  Frank  \n")
      allow($stdout).to receive(:puts)

      result = player.send(:prompt_for_name)

      expect(result).to eq('Frank')
    end
  end

  describe 'attributes' do
    it 'has a readable name attribute' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Eve\n")
      allow($stdout).to receive(:puts)

      player = Player.new(true, true)

      expect(player.name).to eq('Eve')
    end

    it 'has a readable human attribute' do
      player = Player.new(false, true)

      expect(player.human).to be false
    end

    it 'does not allow modifying name' do
      player = Player.new(false, true)

      expect { player.name = 'NewName' }.to raise_error(NoMethodError)
    end

    it 'does not allow modifying human' do
      player = Player.new(false, true)

      expect { player.human = true }.to raise_error(NoMethodError)
    end
  end
end
