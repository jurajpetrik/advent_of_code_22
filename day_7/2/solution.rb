#!/usr/bin/ruby
require 'pry'

class Folder
  attr_reader :folders
  attr_reader :files
  attr_reader :parent_folder
  attr_accessor :name

  def initialize(name, parent_folder = nil)
    self.name = name
    @parent_folder = parent_folder
    @files = []
    @folders = []
  end

  def add_file(size, name)
    f = FileInfo.new(name, size, self)
    @files << f
  end

  def add_folder(name)
    f = Folder.new(name, self)
    @folders << f
  end

  def size
    file_size =
    @size ||=
      self.files.reduce(0) {|sum, f| sum + f.size}  +
      self.folders.reduce(0) {|sum, f| sum + f.size}
  end

  def pretty_name
    return name if parent_folder.nil?
    parent_folder.pretty_name + "/" + self.name
  end

  def print_tree(level=0)
    sep ="  " * level
    sep1 ="  " * (level + 1)
    pp  "#{sep}#{self.name}"
    @folders.each{|f| f.print_tree(level+1)}
    @files.each do |file|
      pp "#{sep1}#{file.name} #{file.size}"
    end
  end
end


class FileInfo #not to clash with system File class
  attr_reader :size, :name
  def initialize(name, size, parent_folder)
    @name = name
    @size = size
    @parent_folder = parent_folder
  end
end

@root = nil
@active_folder = nil

def parse_command(command, response)
  command_parts = command.split(" ")[1..-1]
  if command_parts.first == "cd"
    folder_name = command_parts[1]
    if folder_name == ".."
      @active_folder =  @active_folder.parent_folder
    elsif @active_folder.nil?
        @active_folder = Folder.new(folder_name)
        @root = @active_folder
    else
      @active_folder = @active_folder.folders.find {|f| f.name == folder_name}
    end
  end
  if command_parts.first == "ls"
    response.each do |line|
      words = line.split(" ")
      if words[0] == "dir"
        @active_folder.add_folder(words[1])
      else
        @active_folder.add_file(words[0].to_i, words[1])
      end
    end
  end
end


active_command = nil
active_response = []

File.open('input').each() do |line|
  line.strip! #endline
  if line[0]  == "$"
    parse_command(active_command, active_response) if active_command

    active_command = line
    active_response = []
  else
    active_response << line
  end
end
#one last parse
parse_command(active_command, active_response) if active_command

# @total_small_size = 0
@small = []
def collect_small_folders(small_size, folder)
  @small << folder if folder.size > small_size
  folder.folders.each do |f|
    collect_small_folders(small_size, f)
  end
end

# count_sum_of_small_folders(@root)

# pp "total size of small dirs is #{@total_small_size}"

def find_folder_to_delete(needed_space, folder)
  return nil if folder.size < needed_space
  subfolders = folder.folders.map {|f| find_folder_to_delete(needed_space, f)}.compact
  return folder unless subfolders.any?
  return subfolders.min_by {|f| f.size}
end

total_space = 70000000
unused = total_space - @root.size
total_needed = 30000000
needed = total_needed - unused

folder_to_delete = find_folder_to_delete(needed, @root)
# collect_small_folders(needed, @root)

pp "The smallest folder to delete has size #{folder_to_delete.size}"
# @root.print_tree

# binding.pry
