#!/usr/bin/ruby
require 'pry-byebug'
require 'colorize'

class Grid
  attr_accessor :grid

  def initialize(rows)
    self.grid = rows
  end

  # width is the length of every row
  def width
    self.grid.first.length
  end

  # height is the number of rows
  def height
    self.grid.length
  end

  # for debugging purposes
  def pretty_print(pos_x=0, pos_y=0)
    self.height.times do |y|
      self.width.times do |x|
        text = self.grid[y][x]
        text = text.to_s.red if x == pos_x && y == pos_y
        print text
        print "\n" if x == self.width - 1
      end
    end
    pp "visble left: #{visible_left(pos_x,pos_y)}"
    pp "visble up: #{visible_upwards(pos_x,pos_y)}"
    pp "visble right: #{visible_right(pos_x,pos_y)}"
    pp "visble down: #{visible_downwards(pos_x,pos_y)}"
    pp "scenic score #{scenic_score(pos_x,pos_y)}"
  end

  def scenic_score(x, y)
    visible_left(x, y) * visible_right(x, y) * visible_upwards(x, y) * visible_downwards(x, y)
  end

  def visible_left(x, y)
    height = self.grid[y][x]
    visible = 0

    pointer_x = x
    while true
      break if pointer_x == 0
      visible += 1
      pointer_x -= 1
      break if self.grid[y][pointer_x] >= height
    end

    visible
  end

  def visible_right(x, y)
    height = self.grid[y][x]
    visible = 0

    pointer_x = x

    while true
      break if pointer_x == self.grid.first.length - 1
      visible += 1
      pointer_x += 1
      break if self.grid[y][pointer_x] >= height
    end

    visible
  end

  def visible_upwards(x, y)
    height = self.grid[y][x]
    visible = 0

    pointer_y = y

    while true
      break if pointer_y == 0
      visible += 1
      pointer_y -= 1
      new_height = self.grid[pointer_y][x]
      break if new_height >= height
    end

    visible
  end

  def visible_downwards(x, y)
    height = self.grid[y][x]
    visible = 0

    pointer_y = y

    while true
      break if pointer_y == grid.length - 1
      visible += 1
      pointer_y += 1
      break if grid[pointer_y][x] >= height
    end

    visible
  end

end

lines = File.readlines('input', chomp: true)
rows = lines.map {|l| l.split('').map &:to_i}
grid = Grid.new(rows)

top_scenic_score = 0
top_x, top_y=0

(0..grid.height-1).each do |y|
  (0..grid.width-1).each do |x|
    scenic_score = grid.scenic_score(x,y)
    top_x = x if scenic_score > top_scenic_score
    top_y = y if scenic_score > top_scenic_score
    top_scenic_score = scenic_score if scenic_score > top_scenic_score
  end
end

pp "top scenis score #{top_scenic_score}"


