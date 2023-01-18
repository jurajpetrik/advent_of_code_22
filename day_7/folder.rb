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
    # remember size once you've calculated it
    @size ||=
      self.files.reduce(0) {|sum, f| sum + f.size}  +
      self.folders.reduce(0) {|sum, f| sum + f.size}
  end

  private

  # these are just for debugging purposes

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
