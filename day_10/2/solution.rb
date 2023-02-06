#!/usr/bin/ruby
require 'pry'

lines = File.readlines('input', chomp: true)
x = 1
current_cycle = 1

def print_crt(current_cycle, x)
  cycle_screen_position = current_cycle % 40
  x_covers_current_cycle = cycle_screen_position >= x && cycle_screen_position <= x+2
  symbol_to_print = x_covers_current_cycle ? "#" : "."
  print symbol_to_print
  should_line_break = current_cycle > 0 && current_cycle % 40 == 0  # 40 pixels per row
  # binding.pry if should_line_break
  print "\n" if should_line_break
end

lines.each do |line|
  if line == 'noop'
    print_crt(current_cycle, x)
    current_cycle += 1
  else
    print_crt(current_cycle, x)
    print_crt(current_cycle+1, x)

    instr, amount = line.split(' ')
    raise "unexpected instruction #{instr}" if instr != "addx"

    amount = amount.to_i
    current_cycle += 2
    x += amount
  end
end

