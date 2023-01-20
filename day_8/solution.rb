#!/usr/bin/ruby
require 'pry'
require 'set'

lines = File.readlines('input', chomp: true)

def get_visible_indexes(heights)
  top_height = heights.first
  visible_indexes = [0]
  heights.each_with_index do |height, i|
    visible = height > top_height
    visible_indexes << i if visible
    top_height = height if visible
  end
  visible_indexes
end

rows = lines.map {|l| l.split('').map &:to_i}
cols = rows.transpose

# we're gonna be looking from for sides for visible trees.
# We need to make sure we count each tree only once, even if visible from multiple sides.
# So we use a set to store the grid coordinates of visible trees
visible_trees = Set.new

rows.each_with_index do |row, row_index|
  # look from left to right
  visible_indexes = get_visible_indexes(row)
  visible_indexes.each { |col_index| visible_trees.add([row_index, col_index]) }

  # look from right to left
  visible_indexes = get_visible_indexes(row.reverse)

  visible_indexes.each do |i|
    # rows.length is 99. index 0 is at the end of the array [98], index 98 is at the beginning [0]
    col_index = row.length - 1 - i
    visible_trees.add([row_index, col_index])
  end
end

cols.each_with_index do |col, col_index|
  # look from top to bottom
  visible_indexes = get_visible_indexes(col)
  visible_indexes.each { |row_index| visible_trees.add([row_index, col_index]) }

  # look from bottom up
  visible_indexes = get_visible_indexes(col.reverse)

  visible_indexes.each do |i|
    # rows.length is 99. index 0 is at the end of the array [98], index 98 is at the beginning [0]
    row_index = col.length - 1 - i
    visible_trees.add([row_index, col_index])
  end
end

pp "total visible trees #{visible_trees.length}"
