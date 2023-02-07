#!/usr/bin/ruby
class Monkey
 attr_accessor :items, :operation_string, :test_divisible_by, :monkey_to_pass_if_true, :monkey_to_pass_if_false
 attr_reader :inspected_items_count

 def initialize
   @inspected_items_count = 0
 end

 def monkey_to_pass_to(new_item_value)
   new_item_value % test_divisible_by == 0 ? monkey_to_pass_if_true : monkey_to_pass_if_false
 end

 def has_more_items?
  items.count > 0
 end

 def get_next_item_to_inspect
  @inspected_items_count += 1
  items.shift
 end

 def operation(old)
  do_operation(old) / 3
 end

 private
 # this is super unsafe in the real world. But we are not in the real world
 def do_operation(old)
  eval operation_string
 end

end

monkeys = []

lines = File.readlines('input', chomp: true)

active_monkey = nil

# parse out monkeys from text file
lines.each do |line|
  line.strip!
  if line.start_with? "Monkey"
    active_monkey = Monkey.new
  elsif line.start_with? "Starting items"
    items_string = line.split(": ")[1]
    active_monkey.items = items_string.split(",").map &:to_i
  elsif line.start_with? "Operation"
    active_monkey.operation_string = line.split(":")[1]
  elsif line.start_with? "Test"
    active_monkey.test_divisible_by = line.split(" ").last.to_i
  elsif line.start_with? "If true"
    active_monkey.monkey_to_pass_if_true = line.split(" ").last.to_i
  elsif line.start_with? "If false"
    active_monkey.monkey_to_pass_if_false = line.split(" ").last.to_i
    monkeys << active_monkey
  end
end


20.times do
  monkeys.each do |monkey|
    while monkey.has_more_items?
      item = monkey.get_next_item_to_inspect
      new_item_val = monkey.operation(item)
      new_monkey_index = monkey.monkey_to_pass_to(new_item_val)
      monkeys[new_monkey_index].items << new_item_val
    end
  end
end

sorted = monkeys.sort_by &:inspected_items_count
sorted.reverse!

monkey_business = sorted[0].inspected_items_count * sorted[1].inspected_items_count
p "monkey business value is #{monkey_business}"

