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

    it 'handles guess with more duplicates than secret code has' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red red red green] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to eq(%i[red white])
    end

    it 'handles secret with duplicates when guess has fewer matches' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red red blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red green blue yellow] })

      result = Pins.build_pins(secret_code, guess)

      # Position 0: red matches red (red pin)
      # Position 1: green doesn't match red (no pin)
      # Position 2: blue matches blue (red pin)
      # Position 3: yellow matches yellow (red pin)
      # No white pin because green doesn't match the unmatched red at position 1
      expect(result).to eq(%i[red red red])
    end

    it 'handles secret with duplicates when guess has duplicates in wrong positions' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red red blue blue] })
      guess = instance_double('Code', code_data: { colors: %i[blue blue red red] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to eq(%i[white white white white])
    end

    it 'limits white pins to available duplicates in secret code' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[green green green green] })

      result = Pins.build_pins(secret_code, guess)

      # Position 1: green matches green exactly (red pin)
      # Other green positions don't match because there's only one green in secret
      # and it's already matched at position 1
      expect(result).to eq([:red])
    end

    it 'handles secret with duplicate when guess has one exact and one wrong position' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red red blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red blue red yellow] })

      result = Pins.build_pins(secret_code, guess)

      # Position 0: red matches red exactly (red pin)
      # Position 1: blue doesn't match red, but blue exists at secret pos 2 (white pin)
      # Position 2: red doesn't match blue, but red exists at secret pos 1 (white pin)
      # Position 3: yellow matches yellow exactly (red pin)
      # Should have 2 red pins and 2 white pins
      expect(result.count(:red)).to eq(2)
      expect(result.count(:white)).to eq(2)
      expect(result.length).to eq(4)
    end

    it 'handles guess with more duplicates than secret allows' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red green blue yellow] })
      guess = instance_double('Code', code_data: { colors: %i[red red red green] })

      result = Pins.build_pins(secret_code, guess)

      # Position 0: red matches red exactly (red pin)
      # Position 1: red doesn't match green, and red at secret pos 0 is already matched
      # Position 2: red doesn't match blue, and red at secret pos 0 is already matched
      # Position 3: green doesn't match yellow, but green exists at secret pos 1 (white pin)
      # Only 1 red pin and 1 white pin because extra reds can't match
      expect(result.count(:red)).to eq(1)
      expect(result.count(:white)).to eq(1)
      expect(result.length).to eq(2)
    end

    it 'handles partial matches with overlapping duplicates' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red red blue blue] })
      guess = instance_double('Code', code_data: { colors: %i[red blue red yellow] })

      result = Pins.build_pins(secret_code, guess)

      expect(result).to eq(%i[red white white])
    end

    it 'handles all same color in secret with mixed guess' do
      secret_code = instance_double('SecretCode', code_data: { colors: %i[red red red red] })
      guess = instance_double('Code', code_data: { colors: %i[red green blue yellow] })

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
