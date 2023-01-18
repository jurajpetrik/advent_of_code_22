require_relative 'folder'
require_relative 'file'

class InputReader
  def initialize
    @active_command = nil
    @active_folder = nil
    @root = nil
    @active_response = []
  end

  def process_input(name)
    File.open(name).each() do |line|
      line.strip! #endline
      if line[0]  == "$"
        parse_command(@active_command, @active_response) if @active_command

        @active_command = line
        @active_response = []
      else
        @active_response << line
      end
    end

    parse_command(@active_command, @active_response)
    return @root
  end

  private

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
end
