#!/usr/bin/ruby

require 'pry'
require 'ostruct'

# lines = [
#   "498,4 -> 498,6 -> 496,6",
#   "503,4 -> 502,4 -> 502,9 -> 494,9"
# ]

lines = File.readlines('input', chomp: true)

class Rocks
  attr_reader :coordinates
  ROCK = "#"
  SAND = "o"
  AIR = "."

  def initialize
    @coordinates = []
    @max_y = 0
    @sand_count = 0
  end

  def insert_rock(x,y)
    # first ensure proper array exists so we can insert into it
    @coordinates[x] = [] if coordinates[x].nil?
    @coordinates[x][y] = ROCK
    @max_y = y if y > @max_y
  end

  def pour_sand
    # pretty_print
    init_position = OpenStruct.new({x: 500, y: 0})
    position = init_position.clone
    #first try to go down by one
    while true
      return @sand_count if position.y > @max_y #fell of the edge of the world
      # move directly down if you can
      if get(position.x, position.y + 1) == AIR
        position.y += 1
      # move down and left if you can
      elsif get(position.x - 1, position.y + 1) == AIR
        position.x -= 1
        position.y += 1
      # move down and right if you can
      elsif get(position.x + 1, position.y + 1) == AIR
        position.x += 1
        position.y += 1
      else
        #cannot move anymore
        if position == init_position
          return @sand_count # seems like the world is full
        else
          place_sand(position.x, position.y)
          return pour_sand
        end
      end
    end

  end

  def pretty_print
    (494..503).each do |x|
      (0..9).each do |y|
        print get(x,y)
      end
    print "\n"
    end
  end

  private

  def place_sand(x, y)
    @coordinates[x] = [] if coordinates[x].nil?
    @coordinates[x][y] = SAND
    @sand_count += 1
  end

  def get(x,y)
    @coordinates[x] = [] if coordinates[x].nil?
    @coordinates[x][y] = AIR if coordinates[x][y].nil?
    @coordinates[x][y]
  end
end

def range_between(start, finish)
  start, finish = finish, start if finish < start
  (start..finish)
end


rocks = Rocks.new
lines.each do |line|
  prev_part = nil
  parts = line.split("->")
  parts.each do |part|
    x,y = part.split(",").map &:to_i
    if prev_part
      if prev_part[:x] == x
        range_between(prev_part[:y],y).each do |y|
          rocks.insert_rock(x,y)
        end
      elsif prev_part[:y] == y
        range_between(prev_part[:x],x).each do |x|
          rocks.insert_rock(x,y)
        end
      else
        raise "Unexpected input"
      end
    end
    prev_part = {x: x, y: y}
  end
end

# rocks.pretty_print
grains_of_sand = rocks.pour_sand

puts "Poured in #{grains_of_sand}"
