#!/usr/bin/ruby
# Solution for Advent of Code day 17 part 1
# https://adventofcode.com/2022/day/17
require "./cave"

movements_string = File.readlines("input", chomp: true).first

cave = Cave.new(movements_string)
2022.times { cave.drop_rock }

p cave.rock_tower_height
