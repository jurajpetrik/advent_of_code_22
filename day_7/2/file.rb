class FileInfo #not to clash with system File class
  attr_reader :size, :name
  def initialize(name, size, parent_folder)
    @name = name
    @size = size
    @parent_folder = parent_folder
  end
end
