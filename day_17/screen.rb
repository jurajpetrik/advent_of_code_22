require 'ostruct'
require 'pry'
class Screen
  def initialize
    @grid = Array.new(7) {Array.new(7, false)}
    @max_y = 0
  end

  def position_allowed?(pixels)
    overlapping_existing = pixels.any?{|p| get(p.x, p.y)}
    bellow_bottom = pixels.any?{|p| p.y < 0}
    !bellow_bottom && !overlapping_existing
  end

  def get(x,y)
    @grid[y] = Array.new(7).false if @grid[y].nil?
    @grid[y][x]
  end

  def piece_settled(pixels)
    pixels.each{|p| @grid[p.y][p.x] = true}
  end

  def drop_piece
    start_position = OpenStruct.new(x: 2, y: @max_y + 4)
    piece = HorizontalLine.new(start_position)
    position = piece.pixels
    while true do
      position = piece.move_down_preview
      if position_allowed?(position)
        piece.pixels = position
      else
        break
      end
    end
    piece_settled(piece.pixels)
  end


  def pretty_print
    (0..@max_y + 3).to_a.reverse.each do |y|
      (0..6).each do |x|
        print get(x,y) ? "#" : "."
      end
      print "\n"
    end
  end
end

class HorizontalLine
  attr_accessor :pixels
  # tetris piece shape ####
  def initialize(left_edge)
    @pixels = [
      OpenStruct.new({x: left_edge.x, y: left_edge.y}),
      OpenStruct.new({x: left_edge.x+1, y: left_edge.y}),
      OpenStruct.new({x: left_edge.x+2, y: left_edge.y}),
      OpenStruct.new({x: left_edge.x+3, y: left_edge.y}),
    ]
  end

  def move_right_preview
    @pixels.map{|p| OpenStruct.new({x: p.x+1, y: p.y}) }
  end

  def move_left_preview
    @pixels.map{|p| OpenStruct.new({x: p.x-1, y: p.y}) }
  end

  def move_down_preview
    @pixels.map{|p| OpenStruct.new({x: p.x, y: p.y-1}) }
  end

  # def move_left
  #   @pixels.each{|p| p.x -= 1}
  # end

  # def move_right
  #   @pixels.each{|p| p.x += 1}
  # end

  # def move_left
  #   @pixels.each{|p| p.x -= 1}
  # end

  # def move_down
  #   @pixels.each{|p| p.y -= 1}
  # end

end
