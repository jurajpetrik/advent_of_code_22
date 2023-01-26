#!/usr/bin/ruby

require 'pry'
require 'set'

lines = File.readlines('input', chomp: true)

head_position = [0,0]
tail_position = [0,0]
positions_visited = Set.new
positions_visited.add(tail_position)

def move_tail(head_position, tail_position)
  #react to new head position

  # if same position, do nothing
  # if off by 2 in non diagonal direction, move to be off by one

  # THERE GOTTA BE A BETTER WAY

  # same X coordinate
  if head_position[0] == tail_position[0]
    if head_position[1] - tail_position[1] == 2
      # head is 2 positions below tail
      tail_position = [tail_position[0], tail_position[1] + 1]
    elsif head_position[1] - tail_position[1] == -2
      # head is 2 positions above tail
      tail_position = [tail_position[0], tail_position[1] - 1]
    end
  # same Y coordinate
  elsif head_position[1] == tail_position[1]
    # head is 2 positions to the left of tail
    if head_position[0] - tail_position[0] == -2
      tail_position = [tail_position[0]-1, tail_position[1]]
    # head is 2 positions to the right of tail
    elsif  head_position[0] - tail_position[0] == 2
      tail_position = [tail_position[0]+1, tail_position[1]]
    end

  # different X and Y coordinates, not touching
  elsif (head_position[0] - tail_position[0]).abs == 2 || (head_position[0] - tail_position[0]).abs == 2
    # diagonal shift
    if head_position[0] > tail_position[0]
      tail_position[0] += 1
    else
      tail_position[0] -= 1
    end
    if head_position[1] > tail_position[1]
      tail_position[1] += 1
    else
      tail_position[1] -= 1
    end
  end

  tail_position
end

lines.each do |line|
  dir, amount = line.split(' ')
  amount = amount.to_i
  amount.times do
    case dir
    when "R"
      head_position = [head_position[0]+1, head_position[1]]
    when "L"
      head_position = [head_position[0]-1, head_position[1]]
    when "U"
      head_position = [head_position[0], head_position[1]-1]
    when "D"
      head_position = [head_position[0], head_position[1]+1]
    else
      raise "Unknown direction"
    end

    tail_position = move_tail(head_position, tail_position)
    positions_visited.add(tail_position)
  end
end


puts "Tail visited total #{positions_visited.length} positions"
