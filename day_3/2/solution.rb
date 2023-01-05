#!/usr/bin/ruby
require 'pry'


# returns 1..26 for a..z and 27..52 for A..Z
def char_value(character)
  #assuming proper input cause I'm lazy
  return character.ord - 96 if ('a'..'z').include?(character)
  return character.ord - 38
end

# Open the file in read-only mode
file = File.open("./input", "r")

# Set the number of lines to read at a time
lines_per_iteration = 3

# Initialize a counter variable
line_count = 0

lines = []
total_badge_value = 0
# Loop through the file, reading 10 lines at a time
file.each_line do |line|
  lines << line.strip
  line_count += 1
  if line_count >= lines_per_iteration
    badges = lines[0].split('') & lines[1].split('') & lines[2].split('')
    total_badge_value += char_value(badges.first)
    line_count = 0
    lines = []
  end
end

# Close the file
file.close

p "total badge value #{total_badge_value}"
