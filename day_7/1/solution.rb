#!/usr/bin/ruby

require_relative '../input_reader'

@total_small_size = 0

def count_sum_of_small_folders(folder, total_size=0)
  small_size = 100000
  @total_small_size += folder.size if folder.size < small_size
  folder.folders.each do |f|
    count_sum_of_small_folders(f)
  end
end

root = InputReader.new.process_input("input")
count_sum_of_small_folders(root)

pp "total size of small dirs is #{@total_small_size}"
