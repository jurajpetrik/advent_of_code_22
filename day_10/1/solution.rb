#!/usr/bin/ruby

lines = File.readlines('input', chomp: true)
x = 1
cycles_finished = 0
cycles_to_sample = [20, 60, 100, 140, 180, 220]
next_cycle_to_sample = cycles_to_sample.shift
sum_of_sampled_cycles = 0

lines.each do |line|
  if line == 'noop'
    cycles_finished_after_instr = cycles_finished + 1
    amount = 0
  else
    instr, amount = line.split(' ')
    raise "unexpected instruction #{instr}" if instr != "addx"
    amount = amount.to_i
    cycles_finished_after_instr = cycles_finished + 2
  end
  should_sample_cycle = !next_cycle_to_sample.nil? && cycles_finished <= next_cycle_to_sample && cycles_finished_after_instr >= next_cycle_to_sample
  if should_sample_cycle
    sum_of_sampled_cycles += x * next_cycle_to_sample
    next_cycle_to_sample = cycles_to_sample.shift
  end
  x += amount
  cycles_finished = cycles_finished_after_instr
end

p "sum of register x during sampled cycles is #{sum_of_sampled_cycles}"
