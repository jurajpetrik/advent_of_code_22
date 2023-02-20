class TetrisPiece
  attr_accessor :position
  def move_right_preview
    @position.map{|p| OpenStruct.new({x: p.x+1, y: p.y}) }
  end

  def move_left_preview
    @position.map{|p| OpenStruct.new({x: p.x-1, y: p.y}) }
  end

  def move_down_preview
    @position.map{|p| OpenStruct.new({x: p.x, y: p.y-1}) }
  end
end

class HorizontalLine < TetrisPiece
  # tetris piece shape ####
  def initialize(left_bottom_edge)
    @position = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x+1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x+2, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x+3, y: left_bottom_edge.y}),
    ]
  end
end

class VerticalLine < TetrisPiece
  # tetris piece shape #
  #                    #
  #                    #
  #                    #
  def initialize(left_bottom_edge)
    @position = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 2}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 3}),
    ]
  end
end

class Plus < TetrisPiece
  # tetris piece shape #
  #                   ###
  #                    #
  def initialize(left_bottom_edge)
    @position = [
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y + 2}),
    ]
  end
end

class L < TetrisPiece
  # tetris piece shape #
  #                    #
  #                  ###
  def initialize(left_bottom_edge)
    @position = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y + 1}),
      OpenStruct.new({x: left_bottom_edge.x + 2, y: left_bottom_edge.y + 2}),
    ]
  end
end

class Square < TetrisPiece
  # tetris piece shape ##
  #                    ##
  #
  def initialize(left_bottom_edge)
    @position = [
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y}),
      OpenStruct.new({x: left_bottom_edge.x, y: left_bottom_edge.y+1}),
      OpenStruct.new({x: left_bottom_edge.x + 1, y: left_bottom_edge.y + 1}),
    ]
  end
end
