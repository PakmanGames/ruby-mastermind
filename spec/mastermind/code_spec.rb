# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/code'

RSpec.describe Code do
  describe '#initialize' do
    it 'creates a code with colors and rainbow_colors' do
      colors = %i[red green blue yellow]
      rainbow_colors = %w[red green blue yellow]

      code = Code.new(colors, rainbow_colors)

      expect(code.code_data[:colors]).to eq(colors)
      expect(code.code_data[:rainbow_colors]).to eq(rainbow_colors)
    end
  end

  describe '.create_new_code' do
    it 'creates a new code with four colors' do
      allow(Code).to receive(:colorize).and_return(%w[red green blue yellow])

      code = Code.create_new_code(:red, :green, :blue, :yellow)

      expect(code.code_data[:colors]).to eq(%i[red green blue yellow])
      expect(code.code_data[:rainbow_colors]).to eq(%w[red green blue yellow])
    end

    it 'calls colorize with the correct colors' do
      expect(Code).to receive(:colorize).with(%i[red green blue yellow]).and_return(%w[red green blue yellow])

      Code.create_new_code(:red, :green, :blue, :yellow)
    end
  end

  describe '.colorize' do
    it 'returns an array of colored strings' do
      colors = %i[red green blue]
      result = Code.colorize(colors)

      expect(result).to be_an(Array)
      expect(result.length).to eq(3)
      result.each do |colored|
        expect(colored).to be_a(String)
      end
    end

    it 'handles empty array' do
      result = Code.colorize([])

      expect(result).to eq([])
    end
  end

  describe '#to_s' do
    it 'formats the code with separators' do
      colors = %i[red green blue yellow]
      rainbow_colors = Code.colorize(colors)
      code = Code.new(colors, rainbow_colors)

      result = code.to_s

      expect(result).to start_with('| ')
      expect(result).to include('|')
      expect(result.split('|').length).to eq(6) # 4 colors + 1 empty at start + 1 empty at end
    end

    it 'handles single color' do
      colors = [:red]
      rainbow_colors = Code.colorize(colors)
      code = Code.new(colors, rainbow_colors)

      result = code.to_s

      expect(result).to start_with('| ')
      expect(result).to include('|')
      expect(result.split('|').length).to eq(3) # 1 color + 1 empty at start + 1 empty at end
    end
  end
end
