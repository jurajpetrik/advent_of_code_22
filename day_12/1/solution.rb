#!/usr/bin/ruby
require 'json'
require 'pry'
require './BFS'


pairs = []
lines = File.readlines('input', chomp: true)

graph = Array.new(lines.length) { Array.new(lines.first.length) }

# Find the starting and goal nodes
start = nil
goal = nil

lines.each_with_index do |row, i|
  row.each_char.with_index do |char, j|
    if char == 'S'
      start = [i, j]
    elsif char == 'E'
      goal = [i, j]
    end
    graph[i][j] = char
  end
end

bfs = BFS.new(graph)
length = bfs.find_shortest_path(start, goal)
p "shortest path is #{length}"
