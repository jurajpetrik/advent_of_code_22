#!/usr/bin/ruby
require 'pry'
max_cal = -1
max_cal_index = -1
File.open('input').each_with_index(sep="\n\n") do |batch, index|
  sum_cal = batch.split("\n").map(&:to_i).sum
  if sum_cal > max_cal
    max_cal = sum_cal
    max_cal_index = index
  end
end
p "max cal index: #{max_cal_index} with #{max_cal} calories"
