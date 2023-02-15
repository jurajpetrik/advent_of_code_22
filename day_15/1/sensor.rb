class Sensor
  def initialize(x, y, manhattan_distance)
    @x = x
    @y = y
    @manhattan_distance = manhattan_distance
  end

  def covers_point?(x, y)
    (@x-x).abs + (@y-y).abs <= @manhattan_distance
  end

  def max_x
    @x + @manhattan_distance
  end

  def max_x_in_row(y)
    dist_left = @manhattan_distance - (@y-y).abs
    nil if dist_left < 0
    @x + dist_left
  end

  def min_x_in_row(y)
    dist_left = @manhattan_distance - (@y-y).abs
    nil if dist_left < 0
    @x - dist_left
  end
end
