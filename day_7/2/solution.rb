#!/usr/bin/ruby
require_relative 'file'
require_relative 'folder'
require_relative 'input_reader'

def find_folder_to_delete(needed_space, folder)
  return nil if folder.size < needed_space
  subfolders = folder.folders.map {|f| find_folder_to_delete(needed_space, f)}.compact
  return folder unless subfolders.any?
  return subfolders.min_by {|f| f.size}
end

root = InputReader.new.process_input("input")

total_space = 70000000
unused = total_space - root.size
total_needed = 30000000
needed = total_needed - unused

folder_to_delete = find_folder_to_delete(needed, root)

pp "The smallest folder to delete has size #{folder_to_delete.size}"

