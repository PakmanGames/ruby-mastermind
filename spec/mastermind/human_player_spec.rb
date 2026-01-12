# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/human_player'
require_relative '../../lib/mastermind/secret_code'
require_relative '../../lib/mastermind/code'

RSpec.describe HumanPlayer do
  describe '#initialize' do
    context 'when player is code maker' do
      it 'prompts for name and sets it' do
        allow_any_instance_of(Object).to receive(:gets).and_return("Alice\n")
        allow($stdout).to receive(:puts)

        player = HumanPlayer.new(true)

        expect(player.name).to eq('Alice')
        expect(player.human).to be true
      end

      it 'prompts with code maker role indicator' do
        allow_any_instance_of(Object).to receive(:gets).and_return("Bob\n")
        expect($stdout).to receive(:puts).with("What's your name? (Code Maker)")

        HumanPlayer.new(true)
      end

      it 'trims whitespace from name' do
        allow_any_instance_of(Object).to receive(:gets).and_return("  Charlie  \n")
        allow($stdout).to receive(:puts)

        player = HumanPlayer.new(true)

        expect(player.name).to eq('Charlie')
      end
    end

    context 'when player is code breaker' do
      it 'prompts for name and sets it' do
        allow_any_instance_of(Object).to receive(:gets).and_return("David\n")
        allow($stdout).to receive(:puts)

        player = HumanPlayer.new(false)

        expect(player.name).to eq('David')
        expect(player.human).to be true
      end

      it 'prompts with code breaker role indicator' do
        allow_any_instance_of(Object).to receive(:gets).and_return("Eve\n")
        expect($stdout).to receive(:puts).with("What's your name? (Code Breaker)")

        HumanPlayer.new(false)
      end
    end
  end

  describe '#make_guess' do
    it 'calls SecretCode.enter_code' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Alice\n", "red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)
      code_double = instance_double('Code')
      allow(SecretCode).to receive(:enter_code).and_return(code_double)

      player = HumanPlayer.new(false)
      result = player.make_guess

      expect(SecretCode).to have_received(:enter_code)
      expect(result).to eq(code_double)
    end

    it 'returns a Code object' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Alice\n", "red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)

      player = HumanPlayer.new(false)
      result = player.make_guess

      expect(result).to be_a(Code)
      expect(result.code_data[:colors].length).to eq(4)
    end
  end

  describe '#create_secret_code' do
    it 'calls SecretCode.enter_code' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Bob\n", "red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)
      code_double = instance_double('Code')
      allow(SecretCode).to receive(:enter_code).and_return(code_double)

      player = HumanPlayer.new(true)
      result = player.create_secret_code

      expect(SecretCode).to have_received(:enter_code)
      expect(result).to eq(code_double)
    end

    it 'returns a Code object' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Charlie\n", "red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)

      player = HumanPlayer.new(true)
      result = player.create_secret_code

      expect(result).to be_a(Code)
      expect(result.code_data[:colors].length).to eq(4)
    end
  end

  describe 'inheritance' do
    it 'inherits from Player' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Test\n")
      allow($stdout).to receive(:puts)

      player = HumanPlayer.new(true)

      expect(player).to be_a(Player)
    end

    it 'has human attribute set to true' do
      allow_any_instance_of(Object).to receive(:gets).and_return("Test\n")
      allow($stdout).to receive(:puts)

      player = HumanPlayer.new(true)

      expect(player.human).to be true
    end
  end
end
