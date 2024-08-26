require 'rainbow'

# colours that will be used:
puts 'these are the colors that will be used'
puts Rainbow('blue').bright.blue.bg(:black)
puts Rainbow('blue').black.bg(:black).bright
puts Rainbow('blue').green.bg(:black).bright
puts Rainbow('blue').yellow.bg(:black).bright
puts Rainbow('blue').red.bg(:black).bright
puts Rainbow('blue').magenta.bg(:black).bright
puts Rainbow('blue').cyan.bg(:black).bright
puts Rainbow('blue').silver.bg(:black).bright
