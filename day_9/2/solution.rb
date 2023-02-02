#!/usr/bin/ruby

require 'set'

lines = File.readlines('input', chomp: true)

# first element is head position, last is tail position
rope = Array.new(10) { [0,0] }

positions_visited = Set.new
positions_visited.add(rope.last)

def move_tail(head_position, tail_position)
  new_tail_position = tail_position.clone

  #react to new head position
  # same X coordinate
  if head_position[0] == tail_position[0]
    if head_position[1] - tail_position[1] == 2
      # head is 2 positions below tail
      new_tail_position = [tail_position[0], tail_position[1] + 1]
    elsif head_position[1] - tail_position[1] == -2
      # head is 2 positions above tail
      new_tail_position = [tail_position[0], tail_position[1] - 1]
    end
  # same Y coordinate
  elsif head_position[1] == tail_position[1]
    # head is 2 positions to the left of tail
    if head_position[0] - tail_position[0] == -2
      new_tail_position = [tail_position[0]-1, tail_position[1]]
    # head is 2 positions to the right of tail
    elsif  head_position[0] - tail_position[0] == 2
      new_tail_position = [tail_position[0]+1, tail_position[1]]
    end

  # different X and Y coordinates, not touching
  elsif (head_position[0] - tail_position[0]).abs == 2 || (head_position[1] - tail_position[1]).abs == 2
    # diagonal shift
    if head_position[0] > tail_position[0]
      new_tail_position[0] += 1
    else
      new_tail_position[0] -= 1
    end
    if head_position[1] > tail_position[1]
      new_tail_position[1] += 1
    else
      new_tail_position[1] -= 1
    end
  end

  new_tail_position
end

lines.each do |line|
  dir, amount = line.split(' ')
  amount = amount.to_i
  amount.times do
    head_position = rope[0]
    case dir
    when "R"
      head_position[0] += 1
    when "L"
      head_position[0] -= 1
    when "U"
      head_position[1] -= 1
    when "D"
      head_position[1] += 1
    else
      raise "Unknown direction"
    end

    (1..9).each do |i|
      rope[i] = move_tail(rope[i-1], rope[i])
    end

    positions_visited.add(rope.last)
  end
end

p "tail positions visited #{positions_visited.length}"
