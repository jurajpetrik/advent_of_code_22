#!/usr/bin/ruby
require 'pry'
require 'ostruct'
require 'set'
require './sensor'

lines = File.readlines('input', chomp: true)
row_number = 2000000

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

sensors_in_row = Set.new
beacons_in_row = Set.new
unreachable_in_row = Set.new
sensors = []
max_x = 0
min_x = Float::INFINITY


sensors_and_beacons.each do |sensor, beacon|
  sensors_in_row.add(sensor.x) if sensor.y == row_number
  beacons_in_row.add(beacon.x) if beacon.y == row_number
  manhattan_distance = (sensor.x - beacon.x).abs + (sensor.y - beacon.y).abs
  sensor = Sensor.new(sensor.x, sensor.y, manhattan_distance)
  sensors << sensor
  sensor_max_x = sensor.max_x_in_row(row_number)
  sensor_min_x = sensor.min_x_in_row(row_number)
  max_x = sensor_max_x if sensor_max_x && sensor_max_x > max_x
  min_x = sensor_min_x if sensor_min_x && sensor_min_x < min_x
end

x = min_x
unreachable_count = 0

while x <= max_x
  if !sensors_in_row.include?(x) && !beacons_in_row.include?(x)
    unreachable_count += 1 if sensors.any? {|s| s.covers_point?(x, row_number)}
  end
  x += 1
end

p unreachable_count
