# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/mastermind/secret_code'
require_relative '../../lib/mastermind/code'

RSpec.describe SecretCode do
  describe '.generate_secret_code' do
    it 'generates a code with 4 colors' do
      allow(Code).to receive(:create_new_code).and_return(instance_double('Code'))

      SecretCode.generate_secret_code

      expect(Code).to have_received(:create_new_code)
    end

    it 'generates random colors from available colors' do
      code = SecretCode.generate_secret_code

      expect(code).to be_a(Code)
      expect(code.code_data[:colors].length).to eq(4)
      expect(code.code_data[:colors]).to all(be_a(Symbol))
    end

    it 'uses colors from the available color list' do
      available_colors = %i[red green blue yellow black silver magenta cyan]
      code = SecretCode.generate_secret_code

      code.code_data[:colors].each do |color|
        expect(available_colors).to include(color)
      end
    end
  end

  describe '.enter_code' do
    it 'displays color options' do
      allow(SecretCode).to receive(:display_color_options)
      allow(SecretCode).to receive(:collect_user_colors).and_return(%w[red green blue yellow])
      allow(SecretCode).to receive(:create_new_code).and_return(instance_double('Code'))

      SecretCode.enter_code

      expect(SecretCode).to have_received(:display_color_options)
    end

    it 'collects user colors' do
      allow(SecretCode).to receive(:display_color_options)
      allow(SecretCode).to receive(:collect_user_colors).and_return(%w[red green blue yellow])
      allow(SecretCode).to receive(:create_new_code).and_return(instance_double('Code'))

      SecretCode.enter_code

      expect(SecretCode).to have_received(:collect_user_colors)
    end

    it 'creates a new code from collected colors' do
      colors = %w[red green blue yellow]
      allow(SecretCode).to receive(:display_color_options)
      allow(SecretCode).to receive(:collect_user_colors).and_return(colors)
      allow(SecretCode).to receive(:create_new_code).and_return(instance_double('Code'))

      SecretCode.enter_code

      expect(SecretCode).to have_received(:create_new_code).with(colors)
    end

    it 'returns a Code object' do
      code_double = instance_double('Code')
      allow(SecretCode).to receive(:display_color_options)
      allow(SecretCode).to receive(:collect_user_colors).and_return(%w[red green blue yellow])
      allow(SecretCode).to receive(:create_new_code).and_return(code_double)

      result = SecretCode.enter_code

      expect(result).to eq(code_double)
    end
  end

  describe '.display_color_options' do
    it 'outputs color options to stdout' do
      expect { SecretCode.display_color_options }.to output.to_stdout
    end

    it 'displays instructions' do
      expect { SecretCode.display_color_options }.to output(/You can create a code from 4 of the following colors/).to_stdout
    end
  end

  describe '.collect_user_colors' do
    it 'collects 4 valid colors' do
      allow_any_instance_of(Object).to receive(:gets).and_return("red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)

      result = SecretCode.collect_user_colors

      expect(result).to eq(%w[red green blue yellow])
    end

    it 'ignores invalid colors and continues collecting' do
      allow_any_instance_of(Object).to receive(:gets).and_return("invalid\n", "red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)

      result = SecretCode.collect_user_colors

      expect(result).to eq(%w[red green blue yellow])
    end

    it 'prompts for color until 4 valid colors are collected' do
      allow_any_instance_of(Object).to receive(:gets).and_return("red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)

      expect($stdout).to receive(:puts).at_least(4).times

      SecretCode.collect_user_colors
    end

    it 'only accepts colors from the available color list' do
      allow_any_instance_of(Object).to receive(:gets).and_return("red\n", "green\n", "blue\n", "yellow\n")
      allow($stdout).to receive(:puts)

      result = SecretCode.collect_user_colors

      result.each do |color|
        expect(SecretCode.instance_variable_get(:@colors)).to include(color.to_sym)
      end
    end
  end

  describe '.prompt_for_color' do
    it 'outputs prompt to stdout' do
      expect { SecretCode.prompt_for_color }.to output.to_stdout
    end

    it 'displays color options in prompt' do
      expect { SecretCode.prompt_for_color }.to output(/Enter a color from this list/).to_stdout
    end

    it 'instructs to enter colors one at a time' do
      expect { SecretCode.prompt_for_color }.to output(/Please enter the colors one at a time/).to_stdout
    end
  end

  describe '.create_new_code' do
    it 'converts string colors to symbols' do
      colors = %w[red green blue yellow]
      allow(Code).to receive(:colorize).and_return(%w[red green blue yellow])

      code = SecretCode.create_new_code(colors)

      expect(code.code_data[:colors]).to eq(%i[red green blue yellow])
    end

    it 'calls Code.colorize with symbol colors' do
      colors = %w[red green blue yellow]
      expect(Code).to receive(:colorize).with(%i[red green blue yellow]).and_return(%w[red green blue yellow])

      SecretCode.create_new_code(colors)
    end

    it 'creates a Code instance with correct data' do
      colors = %w[red green blue yellow]
      rainbow_colors = %w[red green blue yellow]
      allow(Code).to receive(:colorize).and_return(rainbow_colors)

      code = SecretCode.create_new_code(colors)

      expect(code).to be_a(Code)
      expect(code.code_data[:colors]).to eq(%i[red green blue yellow])
      expect(code.code_data[:rainbow_colors]).to eq(rainbow_colors)
    end

    it 'handles mixed case color strings' do
      colors = %w[Red GREEN Blue yellow]
      allow(Code).to receive(:colorize).and_return(%w[red green blue yellow])

      code = SecretCode.create_new_code(colors)

      expect(code.code_data[:colors]).to eq(%i[Red GREEN Blue yellow])
    end
  end
end
