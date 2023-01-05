#!/usr/bin/ruby
require 'pry'


# returns 1..26 for a..z and 27..52 for A..Z
def char_value(character)
  #assuming proper input cause I'm lazy
  return character.ord - 96 if ('a'..'z').include?(character)
  return character.ord - 38
end

total_priority = 0
File.open('input').each() do |line|
  line.strip! # remove endline from the end
  midpoint = line.length/2
  first = line[0..midpoint-1]
  second = line[midpoint..line.length]
  common_items = first.split('') & second.split('')
  total_priority += common_items.map {|i| char_value(i)}.sum
end

p "total priority: #{total_priority}"
