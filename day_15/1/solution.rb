#!/usr/bin/ruby

require 'pry'
require 'ostruct'
require 'set'

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

row_number = 2000000
sensors_in_row = Set.new
beacons_in_row = Set.new
unreachable_in_row = Set.new

sensors_and_beacons.each do |sensor, beacon|
  sensors_in_row.add(sensor.x) if sensor.y == row_number
  beacons_in_row.add(beacon.x) if beacon.y == row_number
end

sensors_and_beacons.each_with_index do |sensor_and_beacon, i|
  sensor, beacon = sensor_and_beacon
  manhattan_distance = (sensor.x - beacon.x).abs + (sensor.y - beacon.y).abs
  move_sideways = manhattan_distance - (sensor.y - row_number).abs
  if move_sideways >= 0
    (0..move_sideways).each do |x_offset|
      x_left = sensor.x - x_offset
      x_right = sensor.x + x_offset
      if !sensors_in_row.include?(x_left) && !beacons_in_row.include?(x_left)
        unreachable_in_row.add(x_left)
      end
      if !sensors_in_row.include?(x_right) && !beacons_in_row.include?(x_right)
        unreachable_in_row.add(x_right)
      end
    end
  end
end

p "unreachable in row #{row_number} #{unreachable_in_row.count}"
# binding.pry
