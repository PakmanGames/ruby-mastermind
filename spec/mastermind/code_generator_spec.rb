# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/code_generator'
require_relative '../../lib/mastermind/code'

RSpec.describe CodeGenerator do
  describe '.generate_random_code' do
    it 'generates a Code object' do
      code = CodeGenerator.generate_random_code

      expect(code).to be_a(Code)
    end

    it 'generates a code with exactly 4 colors' do
      code = CodeGenerator.generate_random_code

      expect(code.code_data[:colors].length).to eq(4)
    end

    it 'uses colors from the available color palette' do
      available_colors = CodeGenerator::COLORS
      code = CodeGenerator.generate_random_code

      code.code_data[:colors].each do |color|
        expect(available_colors).to include(color)
      end
    end

    it 'allows duplicate colors' do
      # Run multiple times to increase chance of duplicates
      codes = Array.new(100) { CodeGenerator.generate_random_code }
      codes_with_duplicates = codes.select do |code|
        code.code_data[:colors].uniq.length < 4
      end

      # With 100 random codes, we should get at least one with duplicates
      expect(codes_with_duplicates.length).to be > 0
    end

    it 'generates different codes on multiple calls' do
      code1 = CodeGenerator.generate_random_code
      code2 = CodeGenerator.generate_random_code

      # They might be the same by chance, but with enough attempts they should differ
      codes = Array.new(20) { CodeGenerator.generate_random_code }
      unique_codes = codes.map { |c| c.code_data[:colors] }.uniq

      expect(unique_codes.length).to be > 1
    end

    it 'generates codes with proper colorization' do
      code = CodeGenerator.generate_random_code

      expect(code.code_data[:rainbow_colors]).to be_an(Array)
      expect(code.code_data[:rainbow_colors].length).to eq(4)
    end

    it 'uses Code.create_new_code internally' do
      allow(Code).to receive(:create_new_code).and_return(instance_double('Code'))

      CodeGenerator.generate_random_code

      expect(Code).to have_received(:create_new_code)
    end
  end

  describe 'COLORS constant' do
    it 'contains exactly 8 colors' do
      expect(CodeGenerator::COLORS.length).to eq(8)
    end

    it 'contains the expected colors' do
      expected_colors = %i[red green blue yellow black silver magenta cyan]
      expect(CodeGenerator::COLORS).to match_array(expected_colors)
    end

    it 'is frozen' do
      expect(CodeGenerator::COLORS).to be_frozen
    end
  end
end
