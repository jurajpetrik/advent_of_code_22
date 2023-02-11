#Breadth Search First implementation
require 'set'
require 'colorize'

class BFS
  def initialize(graph)
    @graph = graph
  end

  def find_shortest_path(start, goal)
    visited = NodeSet.new(@graph)
    queue = Queue.new
    goal_reached = false
    queue.enqueue({x: start[0], y: start[1], length: 0})

    i=0
    while queue.size > 0
      i += 1
      node = queue.dequeue
      return node[:length] if node[:x] == goal[0] && node[:y] == goal[1]
      visited.add({x: node[:x], y: node[:y]})

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
    @seen = Set.new
  end

  def enqueue(item)
    unless @seen.include?(item)
      @queue.push(item)
      @seen.add(item)
    end
  end

  def dequeue
    item = @queue.shift
    @seen.delete(item)
    item
  end

  def size
    @queue.size
  end
end

class NodeSet
  def initialize(graph)
    @set = Set.new
    @row_length = graph.first.length
  end

  def add(node)
    @set.add(node_to_key(node))
  end

  def include?(node)
    @set.include?(node_to_key(node))
  end

  def count
    @set.count
  end

  private
  def node_to_key(node)
    node[:x] * @row_length + node[:y]
  end
end
