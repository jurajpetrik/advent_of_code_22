#!/usr/bin/ruby
require 'pry-byebug'

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
end


class FileInfo #not to clash with system File class
  attr_reader :size
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
      @active_folder = @active_folder.folders.first {|f| f.name == folder_name}
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

@total_small_size = 0

def count_sum_of_small_folders(folder)
  small_size = 100000
  @total_small_size += folder.size if folder.size < small_size
  if folder.size < small_size and folder.size > 0
    pp "Found small folder #{folder.pretty_name} "
    pp "Size: #{folder.size}"
  end
  folder.folders.each do |f|
    count_sum_of_small_folders(f)
  end
end

count_sum_of_small_folders(@root)

pp "total size of small dirs is #{@total_small_size}"
