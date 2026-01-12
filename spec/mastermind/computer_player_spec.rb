# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/computer_player'
require_relative '../../lib/mastermind/code_generator'
require_relative '../../lib/mastermind/secret_code'
require_relative '../../lib/mastermind/code'

RSpec.describe ComputerPlayer do
  describe '#initialize' do
    it 'sets name to "Computer"' do
      player = ComputerPlayer.new

      expect(player.name).to eq('Computer')
    end

    it 'sets human attribute to false' do
      player = ComputerPlayer.new

      expect(player.human).to be false
    end

    it 'does not prompt for name' do
      expect($stdin).not_to receive(:gets)

      ComputerPlayer.new
    end
  end

  describe '#make_guess' do
    it 'calls CodeGenerator.generate_random_code' do
      allow(CodeGenerator).to receive(:generate_random_code).and_return(instance_double('Code'))

      player = ComputerPlayer.new
      player.make_guess

      expect(CodeGenerator).to have_received(:generate_random_code)
    end

    it 'returns a Code object' do
      player = ComputerPlayer.new
      result = player.make_guess

      expect(result).to be_a(Code)
      expect(result.code_data[:colors].length).to eq(4)
    end

    it 'generates random codes' do
      player = ComputerPlayer.new
      guesses = Array.new(10) { player.make_guess }
      unique_guesses = guesses.map { |g| g.code_data[:colors] }.uniq

      # With 10 random guesses, we should get some variety
      expect(unique_guesses.length).to be > 1
    end

    it 'uses colors from the available color palette' do
      player = ComputerPlayer.new
      guess = player.make_guess

      guess.code_data[:colors].each do |color|
        expect(CodeGenerator::COLORS).to include(color)
      end
    end
  end

  describe '#create_secret_code' do
    it 'calls SecretCode.generate_secret_code' do
      allow(SecretCode).to receive(:generate_secret_code).and_return(instance_double('Code'))

      player = ComputerPlayer.new
      player.create_secret_code

      expect(SecretCode).to have_received(:generate_secret_code)
    end

    it 'returns a Code object' do
      player = ComputerPlayer.new
      result = player.create_secret_code

      expect(result).to be_a(Code)
      expect(result.code_data[:colors].length).to eq(4)
    end

    it 'generates random secret codes' do
      player = ComputerPlayer.new
      codes = Array.new(10) { player.create_secret_code }
      unique_codes = codes.map { |c| c.code_data[:colors] }.uniq

      # With 10 random codes, we should get some variety
      expect(unique_codes.length).to be > 1
    end

    it 'uses colors from the available color palette' do
      player = ComputerPlayer.new
      code = player.create_secret_code

      code.code_data[:colors].each do |color|
        expect(CodeGenerator::COLORS).to include(color)
      end
    end
  end

  describe 'inheritance' do
    it 'inherits from Player' do
      player = ComputerPlayer.new

      expect(player).to be_a(Player)
    end

    it 'has human attribute set to false' do
      player = ComputerPlayer.new

      expect(player.human).to be false
    end
  end

  describe 'polymorphism' do
    it 'can be used where Player is expected' do
      player = ComputerPlayer.new

      expect(player).to respond_to(:make_guess)
      expect(player).to respond_to(:create_secret_code)
      expect(player).to respond_to(:name)
      expect(player).to respond_to(:human)
    end

    it 'implements make_guess without raising NotImplementedError' do
      player = ComputerPlayer.new

      expect { player.make_guess }.not_to raise_error
    end

    it 'implements create_secret_code without raising NotImplementedError' do
      player = ComputerPlayer.new

      expect { player.create_secret_code }.not_to raise_error
    end
  end
end
