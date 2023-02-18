require 'ostruct'
require 'pry'
require './pieces'

class Screen
  attr_reader :max_y
  WIDTH = 7
  def initialize(movements)
    @movements = movements
    @grid = Array.new(WIDTH) {Array.new(WIDTH, false)}
    @max_y = -1 # the floor is just below the first row
    @horizontal_movement_counter = 0
    @piece_counter = 0
  end

  def position_allowed?(pixels)
    overlapping_existing = pixels.any?{|p| get(p.x, p.y)}
    outside_grid = pixels.any?{|p| p.y < 0 || p.x < 0 || p.x >= WIDTH}
    !outside_grid && !overlapping_existing
  end

  def get(x,y)
    @grid[y] = Array.new(7, false) if @grid[y].nil?
    @grid[y][x]
  end

  def piece_settled(pixels)
    pixels.each do |p|
      @grid[p.y][p.x] = true
      @max_y = p.y if p.y > @max_y
    end
  end

  # everything about this method makes me want to puke
  def next_horizontal_movement
    move = @movements[@horizontal_movement_counter] == ">" ? :move_right_preview : :move_left_preview
    @horizontal_movement_counter = (@horizontal_movement_counter + 1) % @movements.length
    move
  end

  def next_piece
    pieces = [HorizontalLine, Plus, L, VerticalLine, Square]
    piece = pieces[@piece_counter]
    @piece_counter = (@piece_counter + 1) % pieces.length
    piece
  end

  def drop_piece
    start_position = OpenStruct.new(x: 2, y: @max_y + 4)
    piece = next_piece.new(start_position)
    while true do
      horizontal_movement = next_horizontal_movement
      position = piece.send(horizontal_movement)
      piece.position = position if position_allowed?(position)
      position = piece.move_down_preview
      if position_allowed?(position)
        piece.position = position
      else
        break
      end
    end
    piece_settled(piece.position)
  end

  def pretty_print(piece = nil)
    (0..@max_y + 10).to_a.reverse.each do |y|
      (0..6).each do |x|
        sign = "."
        sign = "#" if get(x,y)
        sign = "#" if piece && piece.position.any? {|p| p.x == x && p.y == y}
        print sign
      end
      print "\n"
    end
    print "===================\n"
  end
end
