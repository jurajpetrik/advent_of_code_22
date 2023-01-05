#!/usr/bin/ruby
require 'pry'
# array representing the calories amount per elf
max_cals = []
File.open('input').each_with_index(sep="\n\n") do |batch, index|
  sum_cal = batch.split("\n").map(&:to_i).sum
  max_cals.push(sum_cal)
end
max_cals.sort!.reverse!
p "The top three elves have #{max_cals[0..2].sum} cals together"
