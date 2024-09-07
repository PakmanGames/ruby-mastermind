require_relative 'code'

class SecretCode < Code
  @@COLORS = %i[red green blue yellow black silver magenta cyan]
  @@COLORIZED_COLORS = superclass.colorize(@@COLORS).inject('-') { |acc, curr| "#{acc + curr}-" }

  def self.generate_secret_code
    superclass.create_new_code(@@COLORS.sample, @@COLORS.sample, @@COLORS.sample, @@COLORS.sample)
  end

  def self.enter_code
    puts 'You can create a code from 4 of the following colors: '
    puts @@COLORIZED_COLORS
    color = String.new
    code = []
    until @@COLORS.include?(color.to_sym) && code.length == 4
      puts "Enter a code from this list: #{@@COLORIZED_COLORS}"
      color = gets.chomp
      code.push(color) if @@COLORS.include?(color.to_sym)
    end
    create_new_code(code)
  end

  def self.create_new_code(code)
    code.map!(&:to_sym)
    rainbow_code = superclass.colorize(code)
    Code.new(code, rainbow_code)
  end
end
