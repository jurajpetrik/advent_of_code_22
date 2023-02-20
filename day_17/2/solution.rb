#!/usr/bin/ruby
require './screen'
require 'pry'

line = File.readlines('input', chomp: true).first
s = Screen.new(line)
s.drop_pieces_until_cycle_detected

max_y_incr_per_cycle, rocks_per_cycle, top_20_rows = s.cycle_info
max_y_when_cycle_detected = s.max_y

TOTAL_ROCKS = 1000000000000
rocks_dropped = s.pieces_settled_counter
rocks_left = TOTAL_ROCKS - rocks_dropped

cycles_left = rocks_left / rocks_per_cycle
rocks_dropped_after_last_cycle = rocks_dropped + cycles_left * rocks_per_cycle
rocks_left_after_last_cycle = TOTAL_ROCKS - rocks_dropped_after_last_cycle


rocks_left_after_last_cycle.times { s.drop_piece }
max_y_incr_post_last_cycle =  s.max_y - max_y_when_cycle_detected

final_max_y = max_y_when_cycle_detected + cycles_left * max_y_incr_per_cycle + max_y_incr_post_last_cycle

p final_max_y + 1
