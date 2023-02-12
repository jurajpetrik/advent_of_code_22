#!/usr/bin/ruby

require 'pry'
require 'ostruct'

lines = File.readlines('input', chomp: true)
# lines = [
#   "Sensor at x=2, y=18: closest beacon is at x=-2, y=15",
#   "Sensor at x=9, y=16: closest beacon is at x=10, y=16",
#   "Sensor at x=13, y=2: closest beacon is at x=15, y=3",
#   "Sensor at x=12, y=14: closest beacon is at x=10, y=16",
#   "Sensor at x=10, y=20: closest beacon is at x=10, y=16",
#   "Sensor at x=14, y=17: closest beacon is at x=10, y=16",
#   "Sensor at x=8, y=7: closest beacon is at x=2, y=10",
#   "Sensor at x=2, y=0: closest beacon is at x=2, y=10",
#   "Sensor at x=0, y=11: closest beacon is at x=2, y=10",
#   "Sensor at x=20, y=14: closest beacon is at x=25, y=17",
#   "Sensor at x=17, y=20: closest beacon is at x=21, y=22",
#   "Sensor at x=16, y=7: closest beacon is at x=15, y=3",
#   "Sensor at x=14, y=3: closest beacon is at x=15, y=3",
#   "Sensor at x=20, y=1: closest beacon is at x=15, y=3"
# ]

#process input
sensors_and_beacons = []
lines.each do |line|
  part1, part2 = line.split(":")
  sensor_x = part1.split(",").first.split("=").last.to_i
  sensor_y = part1.split(",").last.split("=").last.to_i
  beacon_x = part2.split(",").first.split("=").last.to_i
  beacon_y = part2.split(",").last.split("=").last.to_i
  sensors_and_beacons << [OpenStruct.new({x: sensor_x, y: sensor_y}), OpenStruct.new({x: beacon_x, y: beacon_y})]
end

# used to mark the reference where a beacon cannot reside
class Grid
  BEACON_UNREACHABLE = "#"
  BEACON = "B"
  SENSOR = "S"
  EMPTY = "."

  # hack to deal with negative coordinates
  OFFSET = 100000

  def initialize
    @grid = []
  end

  def mark_beacon_unreachable(x,y)
    mark(x, y, BEACON_UNREACHABLE) if get(x, y) == EMPTY
  end

  def mark_beacon(x,y)
    mark(x, y, BEACON)
  end

  def mark_sensor(x,y)
    mark(x, y, SENSOR)
  end

  def pretty_print
    (-2..22).each do |x|
      (-4..26).each do |y|
        print get(y,x)
      end
      print "\n"
    end
  end

  def get(x,y)
    x = x + OFFSET
    y = y + OFFSET
    row = @grid[y]
    return EMPTY unless row
    point = row[x]
    point.nil? ? EMPTY : point
  end

  def count_unreachable_in_row(x)
    x = x + OFFSET
    row = @grid[x]
    return row.nil? ? 0 : row.count(BEACON_UNREACHABLE)
  end

  private
  def mark(x, y, symbol)
    x = x + OFFSET
    y = y + OFFSET
    if x < 0 || y < 0
      binding.pry
      raise "Cannot mark a negative index in an array, #{x}, #{y}"
    end
    @grid[y] = [] unless @grid[y]
    @grid[y][x] = symbol
  end
end

grid = Grid.new

sensors_and_beacons.each do |sensor, beacon|
  grid.mark_beacon(beacon.x, beacon.y)
  grid.mark_sensor(sensor.x, sensor.y)
end


sensors_and_beacons.each do |sensor, beacon|
  manhattan_distance = (sensor.x - beacon.x).abs + (sensor.y - beacon.y).abs
  (0..manhattan_distance).each do |move_sideways|
    x_left = sensor.x - move_sideways
    x_right = sensor.x + move_sideways
    distance_remaining = manhattan_distance - move_sideways
      (0..distance_remaining).each do |dist|
        y_up = sensor.y - dist
        y_down = sensor.y + dist
        [
          [x_left,y_up],
          [x_left,y_down],
          [x_right,y_up],
          [x_right,y_down],
        ].each do |x,y|
          grid.mark_beacon_unreachable(x,y)
        end
      end
  end
end

unreachable_row = 2000000
p "unreachable in row #{unreachable_row} #{grid.count_unreachable_in_row(unreachable_row)}"
