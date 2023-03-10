#!/usr/bin/ruby
require 'json'

pairs = []
lines = File.readlines('input', chomp: true)
#parse lines into pairs
i = 0
while i < lines.length - 1 do
  left = JSON::parse(lines[i])
  right = JSON::parse(lines[i + 1])
  i = i + 3 #skip newline
  pairs << [left, right]
end

def compare_ints(left_val, right_val)
  return 0 if left_val == right_val # equal value should continue
  return -1 left_val < right_val # correct order
  return 1 # incorrect order
end

def compare_arrays(left_array, right_array)
  return -1 if left_array.empty? && !right_array.empty? # left array run out of items first, correct order
  return 1 if !left_array.empty? && right_array.empty? # right array run out of items first, incorrect order
  return 0 if left_array.empty? && right_array.empty? # both arrays run out of items, continue checking
  # there are items left in both arrays

  left_val = left_array.first
  right_val = right_array.first

  if left_val.class == Integer
    if right_val.class == Integer
      comp = compare_ints(left_val, right_val)
    elsif right_val.class == Array
      comp = compare_arrays([left_val], right_val)
    else
      raise "Unexpected right_val type #{right_val.class}"
    end
  elsif left_val.class == Array
    if right_val.class == Array
      comp = compare_arrays(left_val, right_val)
    elsif right_val.class == Integer
      comp = compare_arrays(left_val, [right_val])
    else
      raise "Unexpected right_val type #{left_val.class}"
    end
  else
    raise "Unexpected left_val type #{left_val.class}"
  end

  if comp == -1
    return compare_arrays(left_array.drop(1), right_array.drop(1))
  else
    return comp
  end
end

sum_of_indices_of_correct_pairs = 0
pairs.each_with_index do |pair,i|
  left, right = pair
  result = compare_arrays(left, right)
  sum_of_indices_of_correct_pairs += i+1 if result == 1
end

p "Sum of indices of correct pairs is #{sum_of_indices_of_correct_pairs}"
