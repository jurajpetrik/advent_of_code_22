#!/usr/bin/ruby
require 'pry'
total_score = 0
File.open('input').each() do |line|
  opponent, mine = line.split
  round_score = 0
  # i played rock
  if mine == "X"
    round_score += 1 # 1 point for playing paper
    round_score += 3 if opponent == "A" # 3 points for draw
    round_score += 6 if opponent == "C" # 6 points for win
  end
  # i played paper
  if mine == "Y"
    round_score += 2 # 2 points for playing paper
    round_score += 3 if opponent == "B" # 3 points for draw
    round_score += 6 if opponent == "A" # 6 points for win
  end
  # i played scissors
  if mine == "Z"
    round_score += 3 # 3 points for playing scissors
    round_score += 3 if opponent == "C" # 3 points for draw
    round_score += 6 if opponent == "B" # 6 points for win
  end
  total_score += round_score
end

p "total score: #{total_score}"
