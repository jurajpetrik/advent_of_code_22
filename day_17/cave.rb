require 'ostruct'
require './rocks'

class Cave
  attr_reader :total_rocks_dropped
  WIDTH = 7
  ROCK_SHAPES = [HorizontalLine, Plus, L, VerticalLine, Square]

  def initialize(jet_stream_string)
    # string such as "<<<>>><<<" that represents left and right movements of a rock. It is looped over, when you come to the end
    @jet_stream_string = jet_stream_string
    # position in the jet_stream
    @jet_stream_index = 0
    # 2d array. True represents a position where a part of a rock has landed. False represents empty air
    @grid = Array.new(WIDTH) {Array.new(WIDTH, false)}
    # max_y represents the highest position that's covered by a rock . The floor is just below the first row so it starts being -1
    @max_y = -1
    # position in the ROCK_SHAPES array
    @rock_shape_index = 0
    # hash used to figure out if the pattern of dropped rocks is repeating itself
    @cycle_detection_hash = {}
    @total_rocks_dropped = 0
  end

  # drop rocks until you find a repeating cycle in the grid
  def drop_rocks_until_cycle_found
    while true do
      drop_rock
      key = cycle_detection_key
      break if @cycle_detection_hash[key]
      @cycle_detection_hash[key] = [@max_y, @total_rocks_dropped]
    end
  end

  # Get a new rock, initalize it to the required position, and drop it until it cannot move down anymore,
  def drop_rock
    rock = get_next_rock
    rock_did_move = true
    while rock_did_move do
      move_rock_in_jetstream(rock)
      rock_did_move = move_rock_down(rock)
    end
    # after the rock cannot move down anymore, let's add its final position to the grid
    add_rock_to_grid(rock)
    @total_rocks_dropped += 1
  end

  # move rock one position left or right according to the jetstream, if the cave boundaries allow it
  def move_rock_in_jetstream(rock)
    move = @jet_stream_string[@jet_stream_index] == ">" ? :move_right_preview : :move_left_preview
    coordinates = rock.send(move)
    @jet_stream_index = (@jet_stream_index + 1) % @jet_stream_string.length

    if rock_coordinates_allowed?(coordinates)
      rock.coordinates = coordinates
    end
  end

  # move rock one position down if possible, return true if the rock could move, false otherwise
  def move_rock_down(rock)
    coordinates = rock.move_down_preview
    if rock_coordinates_allowed?(coordinates)
      rock.coordinates = coordinates
      return true
    else
      return false
    end
  end

  # Add rock's position to the grid
  def add_rock_to_grid(rock)
    rock.coordinates.each do |p|
      @grid[p.y][p.x] = true
      @max_y = p.y if p.y > @max_y
    end
  end

  # check if a rock is allowed to move to the given position
  def rock_coordinates_allowed?(position)
    overlapping_existing = position.any?{|p| covered_by_rock?(p.x, p.y)}
    outside_grid = position.any?{|p| p.y < 0 || p.x < 0 || p.x >= WIDTH}
    !outside_grid && !overlapping_existing
  end

  # Return true if a given coordinate is covered by a rock
  def covered_by_rock?(x,y)
    # the grid grows as we drop new rocks. To avoid nil access, create new rows as we access them
    @grid[y] = Array.new(7, false) if @grid[y].nil?
    @grid[y][x]
  end

  def rock_tower_height
    @max_y + 1
  end

  def cycle_detected?
    @cycle_detection_hash[cycle_detection_key]
  end

  def cycle_info
    raise "Haven't detected a cycle, cannot return cycle info" unless cycle_detected?
    max_y, pieces_settled = @cycle_detection_hash[cycle_detection_key]
    delta_max_y = @max_y - max_y
    delta_pieces = @total_rocks_dropped - pieces_settled
    return [delta_max_y, delta_pieces, top_20_rows]
  end

  def top_20_rows
    @grid[@max_y-20..@max_y]
  end

  def cycle_detection_key
    # if the top 20 rows look the same as the last time we had this shape and this wind, there's a good chance we found a repeating cycle
    # the number 20 is randomly chosen, it turns out that it works for the input, but there is no proof that it would work for all inputs
    key = [
      @jet_stream_index,
      @rock_shape_index,
      top_20_rows
    ]
  end

  # initialize the next rock of the proper shape and at the proper position
  def get_next_rock
    rock_shape = ROCK_SHAPES[@rock_shape_index]
    @rock_shape_index = (@rock_shape_index + 1) % ROCK_SHAPES.length
    # Every new rock starts 2 positions from the left edge of the cave and 4 position about the highest covered point
    rock_start_coordinates = OpenStruct.new(x: 2, y: @max_y + 4)
    rock_shape.new(rock_start_coordinates)
  end

  # helper method for debugging
  def pretty_print(rock = nil)
    (0..@max_y + 10).to_a.reverse.each do |y|
      (0..6).each do |x|
        sign = "."
        sign = "#" if covered_by_rock?(x,y)
        sign = "@" if rock && rock.position.any? {|p| p.x == x && p.y == y}
        print sign
      end
      print "\n"
    end
    print "===================\n"
  end
end
