require 'ostruct'
class Rock
  attr_accessor :coordinates
  def move_right_preview
    @coordinates.map{|p| OpenStruct.new({x: p.x+1, y: p.y})}
  end

  def move_left_preview
    @coordinates.map{|p| OpenStruct.new({x: p.x-1, y: p.y})}
  end

  def move_down_preview
    @coordinates.map{|p| OpenStruct.new({x: p.x, y: p.y-1})}
  end
end

class HorizontalLine < Rock
  # rock shape ####
  def initialize(left_bottom_edge)
    @coordinates = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x+1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x+2, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x+3, y: left_bottom_edge.y}),
    ]
  end
end

class VerticalLine < Rock
  # rock shape #
  #                    #
  #                    #
  #                    #
  def initialize(left_bottom_edge)
    @coordinates = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 2}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 3}),
    ]
  end
end

class Plus < Rock
  # rock shape #
  #                   ###
  #                    #
  def initialize(left_bottom_edge)
    @coordinates = [
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y + 2}),
    ]
  end
end

class L < Rock
  # rock shape #
  #                    #
  #                  ###
  def initialize(left_bottom_edge)
    @coordinates = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y + 2}),
    ]
  end
end

class Square < Rock
  # rock shape ##
  #                    ##
  #
  def initialize(left_bottom_edge)
    @coordinates = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y+1}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y + 1}),
    ]
  end
end
