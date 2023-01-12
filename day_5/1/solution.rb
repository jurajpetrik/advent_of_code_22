#!/usr/bin/ruby
require 'pry'

def is_digit?(s)
  code = s.ord
  # 48 is ASCII code of 0
  # 57 is ASCII code of 9
  48 <= code && code <= 57 && s.length == 1
end

total_overlaps = 0
stacks = []
lines = []
moves = []
reading_stacks = true
indices = []

File.open('input').each do |line|
  if reading_stacks
    if line[1] == "1"
      # hit the line with numbers of columns,
      reading_stacks = false
      chars = line.split('')
      chars.each_with_index do |c, i|
        indices << i if is_digit?(c)
      end
    else
      # reading
      lines << line
    end
  else
    next if line.strip == ""
    words = line.split(" ")
    amount = words[1].to_i
    from = words[3].to_i
    to = words[5].to_i
    moves << {from: from, to: to, amount: amount}
  end
  # line = line[0..line.length-2] # drop trailing newline
  # stacks_in_line = line.length / 4 + 1 # 4 chars per item in the input
  # items = []
  # pointer = 1
  # while pointer < line.length
  #   items << line[pointer]
  #   pointer += 4
  # end
  # stacks << items
end


### parse out lines into stacks representing columns of items
stacks = Array.new(indices.length) {[]}
lines.reverse.each do |line|
  indices.each_with_index do |index_of_letter_in_line, index_of_stack|
    item_symbol = line[index_of_letter_in_line]
    stacks[index_of_stack] << item_symbol if item_symbol != " " && item_symbol != nil
  end
end
pp stacks
binding.pry moves
