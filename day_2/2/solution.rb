#!/usr/bin/ruby
require 'pry'
total_score = 0
File.open('input').each() do |line|
  opponent, mine = line.split
  round_score = 0
  # i wanna lose
  if mine == "X"
    case opponent
    # he played rock, 3 points for playing scissors, 0 points for loss
    when "A" then round_score += 3
    # he played paper, 1 point for playing rock, 0 points for loss
    when "B" then round_score += 1
    # he played scissors, 2 point for playing paper, 0 points for loss
    when "C" then round_score += 2
    end
  end
  # i wanna draw
  if mine == "Y"
    round_score += 3 # 3 points for a draw
    case opponent
    # 1 points for playing rock
    when "A" then round_score += 1
    # 2 points for playing paper
    when "B" then round_score += 2
    # 3 point for playing scissors
    when "C" then round_score += 3
    end
  end
  if mine == "Z"
    # i wanna win
    round_score += 6
    case opponent
    # 2 points for playing paper
    when "A" then round_score += 2
    # 2 points for playing scissors
    when "B" then round_score += 3
    # 3 point for playing rock
    when "C" then round_score += 1
    end
  end
  total_score += round_score
end

p "total score: #{total_score}"
