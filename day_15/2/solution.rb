#!/usr/bin/ruby
# Solution for https://adventofcode.com/2022/day/15

require 'ostruct'
require 'set'
require './sensor'

lines = File.readlines('input', chomp: true)

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

MAX = 4000000
MIN = 0

beacons = Set.new
sensors = []

sensors_and_beacons.each do |sensor, beacon|
  beacons.add({x: beacon.x, y: beacon.y})

  manhattan_distance = (sensor.x - beacon.x).abs + (sensor.y - beacon.y).abs
  sensor = Sensor.new(sensor.x, sensor.y, manhattan_distance)
  sensors << sensor
end

sensors.each do |sensor|
  sensor.run_perimeter do |x,y|
    next if x < MIN || x > MAX || y < MIN || y > MAX
    next if beacons.include?({x: x, y: y})
    if sensors.none? {|s| s.covers_point?(x,y)}
      tuning_frequency  = x * 4000000 + y
      puts "Found point: x: #{x}, y: #{y}, tuning frequency: #{tuning_frequency}"
      return
    end
  end
end
