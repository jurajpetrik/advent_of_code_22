#!/usr/bin/ruby
require 'json'
require 'pry'
require './BFS'


pairs = []
lines = File.readlines('input', chomp: true)

graph = Array.new(lines.length) { Array.new(lines.first.length) }

# Find the starting and goal nodes
possible_starts = []
goal = nil

lines.each_with_index do |row, i|
  row.each_char.with_index do |char, j|
    if char == 'S' || char == 'a'
      possible_starts << [i, j]
    elsif char == 'E'
      goal = [i, j]
    end
    graph[i][j] = char
  end
end

bfs = BFS.new(graph)
length = possible_starts.map{|start| bfs.find_shortest_path(start, goal)}.compact.min
p "shortest path is #{length}"
