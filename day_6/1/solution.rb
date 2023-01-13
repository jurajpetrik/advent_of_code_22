#!/usr/bin/ruby
require 'pry'

class Buffer
  attr_reader :index
  Length = 4
  @chars

  def initialize
    @chars = []
    @index = 0
  end

  def push(char)
    @index += 1
    if @chars.length < Length
      @chars.push(char)
    else
      @chars = @chars[1..-1] + [char]
    end
  end

  def marker_found?
    @chars.length == Length && @chars.uniq.length == Length
  end
end

b = Buffer.new
File.open("input").each_char do |char|
  b.push(char)
  break if b.marker_found?
end

p "marker found at index #{b.index}"
