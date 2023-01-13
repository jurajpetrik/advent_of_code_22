#!/usr/bin/ruby
require 'pry'

class Buffer
  attr_reader :index

  def initialize(length = 4)
    @chars = []
    @index = 0
    @length = length
  end

  def push(char)
    @index += 1
    if @chars.length < @length
      @chars.push(char)
    else
      @chars = @chars[1..-1] + [char]
    end
  end

  def marker_found?
    @chars.length == @length && @chars.uniq.length == @length
  end
end

b = Buffer.new
File.open("input").each_char do |char|
  b.push(char)
  break if b.marker_found?
end

p "marker found at index #{b.index}"
