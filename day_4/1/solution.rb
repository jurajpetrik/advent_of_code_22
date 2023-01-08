#!/usr/bin/ruby
require 'pry'
total_overlaps = 0
File.open('input').each() do |line|
  elf1, elf2 = line.strip.split(',')
  elf1_from, elf1_to = elf1.split('-').map(&:to_i)
  elf2_from, elf2_to = elf2.split('-').map(&:to_i)
  total_overlaps += 1 if (elf1_from >= elf2_from && elf1_to <= elf2_to) || (elf2_from >= elf1_from && elf2_to <= elf1_to)
end

p "total full overlaps: #{total_overlaps}"
