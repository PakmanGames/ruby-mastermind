# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/pins'
require_relative '../../lib/mastermind/code'
require_relative '../../lib/mastermind/secret_code'

RSpec.describe Pins do
  describe '.generate_pins' do
    it 'returns a hash with pins and rainbow_pins' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red green blue yellow] })

      result = Pins.generate_pins(secret_code, guess)

      expect(result).to be_a(Hash)
      expect(result).to have_key(:pins)
      expect(result).to have_key(:rainbow_pins)
    end

    it 'calls build_pins with secret_code and guess' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red green blue yellow] })

      expect(Pins).to receive(:build_pins).with(secret_code, guess).and_return(%i[red red red red])

      Pins.generate_pins(secret_code, guess)
    end
  end

  describe '.build_pins' do
    it 'returns red pins for correct colors in correct positions' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red green blue yellow] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to eq(%i[red red red red])
    end

    it 'returns white pins for correct colors in wrong positions' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[green red yellow blue] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to include(:white)
      expect(result).not_to include(:red)
    end

    it 'returns red pins for correct positions and white for correct colors in wrong positions' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red blue green yellow] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to include(:red)
      expect(result).to include(:white)
    end

    it 'returns empty array when no colors match' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[black black black black] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to eq([])
    end

    it 'handles duplicate colors correctly' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red red blue blue] })
      guess = instance_double('Code', code_data: { colors: %i[red blue red blue] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to include(:red)
      expect(result).to include(:white)
    end

    it 'returns only red pins when position matches, even if color appears elsewhere' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red red red red] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to eq([:red])
    end
  end

  describe '.colorize' do
    it 'returns an array of colored strings' do
      pins = %i[red white]
      result = Pins.colorize(pins)

      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
      result.each do |colored|
        expect(colored).to be_a(String)
      end
    end

    it 'handles empty array' do
      result = Pins.colorize([])

      expect(result).to eq([])
    end

    it 'handles single pin' do
      result = Pins.colorize([:red])

      expect(result).to be_an(Array)
      expect(result.length).to eq(1)
    end
  end

  describe '.display' do
    it 'formats pins with separators' do
      pins = {
        rainbow_pins: %w[red white red white]
      }

      result = Pins.display(pins)

      expect(result).to start_with('-')
      expect(result).to include('red')
      expect(result).to include('white')
    end

    it 'handles empty pins' do
      pins = {
        rainbow_pins: []
      }

      result = Pins.display(pins)

      expect(result).to eq('-')
    end

    it 'handles single pin' do
      pins = {
        rainbow_pins: ['red']
      }

      result = Pins.display(pins)

      expect(result).to start_with('-')
      expect(result).to include('red')
    end
  end
end
