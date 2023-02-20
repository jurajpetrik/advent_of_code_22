require 'ostruct'
require 'pry'
require './pieces'

class Screen
  attr_accessor :max_y, :grid, :pieces_settled_counter, :horizontal_movement_counter, :piece_counter
  WIDTH = 7

  def initialize(movements)
    @movements = movements
    @grid = Array.new(WIDTH) {Array.new(WIDTH, false)}
    @max_y = -1 # the floor is just below the first row
    @horizontal_movement_counter = 0
    @piece_counter = 0
    @cycle_detection_hash = {}
    @pieces_settled_counter = 0
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

  def settle_piece(pixels)
    pixels.each do |p|
      @grid[p.y][p.x] = true
      @max_y = p.y if p.y > @max_y
    end
    @pieces_settled_counter += 1
  end

  # everything about this method makes me want to puke
  def next_horizontal_movement
    move = @movements[@horizontal_movement_counter] == ">" ? :move_right_preview : :move_left_preview
    @horizontal_movement_counter = (@horizontal_movement_counter + 1) % @movements.length
    move
  end

  def cycle_detected?
    @cycle_detection_hash[cycle_detection_key]
  end

  def cycle_info
    raise "Haven't detected a cycle, cannot return cycle info" unless cycle_detected?
    max_y, pieces_settled = @cycle_detection_hash[cycle_detection_key]
    delta_max_y = @max_y - max_y
    delta_pieces = @pieces_settled_counter - pieces_settled
    return [delta_max_y, delta_pieces, top_20_rows]
  end

  def top_20_rows
    @grid[@max_y-20..@max_y]
  end

  def cycle_detection_key
    # if the top 20 rows look the same as the last time we had this shape and this wind, there's a good chance we found a repeating cycle
    key = [
      @horizontal_movement_counter,
      @piece_counter,
      top_20_rows
    ]
  end

  def next_piece
    pieces = [HorizontalLine, Plus, L, VerticalLine, Square]
    piece = pieces[@piece_counter]
    @piece_counter = (@piece_counter + 1) % pieces.length
    piece
  end

  def start_coordinates
    OpenStruct.new(x: 2, y: @max_y + 4)
  end

  def drop_pieces_until_cycle_detected
    while true do
      drop_piece
      key = cycle_detection_key
      break if @cycle_detection_hash[key]
      @cycle_detection_hash[key] = [@max_y, @pieces_settled_counter]
    end
  end

  def drop_piece
    piece = next_piece.new(start_coordinates)
    while true do
      horizontal_movement = next_horizontal_movement
      position = piece.send(horizontal_movement)

      if position_allowed?(position)
        piece.position = position
      end


      position = piece.move_down_preview
      if position_allowed?(position)
        piece.position = position
      else
        break
      end
    end
    settle_piece(piece.position)
  end

  def pretty_print(piece = nil)
    (0..@max_y + 10).to_a.reverse.each do |y|
      (0..6).each do |x|
        sign = "."
        sign = "#" if get(x,y)
        sign = "@" if piece && piece.position.any? {|p| p.x == x && p.y == y}
        print sign
      end
      print "\n"
    end
    print "===================\n"
  end
end
