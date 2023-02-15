class Sensor
  def initialize(x, y, manhattan_distance)
    @x = x
    @y = y
    @manhattan_distance = manhattan_distance
  end

  def covers_point?(x, y)
    (@x - x).abs + (@y - y).abs <= @manhattan_distance
  end

  # run provided block for every point on the sensor's perimeter, passing it the points parameters
  # perimeter is the set of points just outside of the sensors coverage / manhattan distance
  def run_perimeter
    raise "expecting block" unless block_given?
    perimeter = @manhattan_distance + 1
    yield(@x, @y - perimeter)
    ((-1 * (perimeter - 1))..(perimeter - 1)).each do |move_vertically|
      move_horizontally = perimeter - move_vertically.abs
      yield(@x + move_horizontally, @y + move_vertically)
      yield(@x - move_horizontally, @y + move_vertically)
    end
    yield(@x, @y + perimeter)
  end
end
