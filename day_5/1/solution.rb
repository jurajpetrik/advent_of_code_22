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
indices = [] #the first element is the column index at this the first column's symbol is in each row

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
    from = words[3].to_i - 1 # 0 index it
    to = words[5].to_i - 1 # 0 index it
    moves << {from: from, to: to, amount: amount}
  end
end


### parse out lines into stacks representing columns of items
stacks = Array.new(indices.length) {[]}
lines.reverse.each do |line|
  indices.each_with_index do |index_of_letter_in_line, index_of_stack|
    item_symbol = line[index_of_letter_in_line]
    stacks[index_of_stack] << item_symbol if item_symbol != " " && item_symbol != nil
  end
end

### play out moves
moves.each do |move|
  move[:amount].times { stacks[move[:to]].push(stacks[move[:from]].pop)}
end

result = ""
stacks.each{|s| result += s.last}
pp result
