#Breadth Search First implementation
require 'set'
require 'colorize'

class BFS
  def initialize(graph)
    @graph = graph
  end

  def find_shortest_path(start, goal)
    visited = Set.new
    queue = Queue.new
    goal_reached = false
    queue.enqueue({x: start[0], y: start[1], length: 0})

    while !goal_reached
      node = queue.dequeue
      return node[:length] if node[:x] == goal[0] && node[:y] == goal[1]
      visited.add({x: node[:x], y: node[:y]})

      # puts "Checking node: #{node}"
      # puts "Node height: #{node_height(node)}"

      nodes_to_consider = [
        {x: node[:x], y: node[:y] + 1},
        {x: node[:x], y: node[:y] - 1},
        {x: node[:x] + 1, y: node[:y]},
        {x: node[:x] - 1, y: node[:y]},
      ]
      nodes_to_consider.each do |node_to_consider|
        next unless within_bounds?(node_to_consider)
        height_acceptable = node_height(node_to_consider) - node_height(node) <= 1
        if height_acceptable && !visited.include?(node_to_consider)
          queue.enqueue(node_to_consider.merge({length: node[:length] + 1}))
        end
      end
    end
  end

  def pretty_print(node)
    @graph.length.times do |row|
      @graph.first.length.times do |column|
        height = @graph[row][column].to_s
        height = height.yellow if node[:previous].index {|node| node[:x] == row && node[:y] == column }
        height = height.red if node[:previous].last[:x] == row && node[:previous].last[:y] == column
        print height + " "
      end
      print "\n"
    end
  end

  private

  def within_bounds?(node)
    node[:x] >= 0 && node[:x] < @graph.length && node[:y] >= 0 && node[:y] < @graph.first.length
  end

  def node_height(node)
    letter = @graph[node[:x]][node[:y]]
    letter = 'a' if letter == 'S'
    letter = 'z' if letter == 'E'
    letter.ord
  end
end

class Queue
  def initialize
    @queue = []
  end

  def enqueue(x)
    @queue.push(x)
  end

  def dequeue
    @queue.shift
  end
end
