#!/usr/bin/ruby
require 'pry'
lines = File.readlines('input', chomp: true)
lines = lines.map do |line|
  dir, amount = line.split(' ')
  amount = amount.to_i
  [dir, amount]
end
binding.pry
