#!/usr/bin/ruby
require './screen'
require 'pry'

line = File.readlines('input', chomp: true).first
# line = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
s = Screen.new(line)
2022.times do
  s.drop_piece
end
p s.max_y + 1
