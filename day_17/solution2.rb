#!/usr/bin/ruby
require "./cave"

# Solution for Advent of Code day 17 part 2
# https://adventofcode.com/2022/day/17

movements_string = File.readlines("input", chomp: true).first

cave = Cave.new(movements_string)
cave.drop_rocks_until_cycle_found

rock_tower_height_incr_per_cycle, rocks_per_cycle, top_20_rows = cave.cycle_info
rock_tower_height_when_cycle_detected = cave.rock_tower_height

total_rocks = 1000000000000
rocks_dropped = cave.total_rocks_dropped
rocks_left = total_rocks - rocks_dropped

cycles_left = rocks_left / rocks_per_cycle
rocks_dropped_after_last_cycle = rocks_dropped + cycles_left * rocks_per_cycle
rocks_left_after_last_cycle = total_rocks - rocks_dropped_after_last_cycle
rock_tower_height_incr_during_cycles = cycles_left * rock_tower_height_incr_per_cycle

rocks_left_after_last_cycle.times { cave.drop_rock }
rock_tower_height_incr_post_last_cycle = cave.rock_tower_height - rock_tower_height_when_cycle_detected

final_rock_tower_height = rock_tower_height_when_cycle_detected +
                          rock_tower_height_incr_during_cycles +
                          rock_tower_height_incr_post_last_cycle

p final_rock_tower_height
