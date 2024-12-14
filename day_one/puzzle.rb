require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

lefts = elf_inputs.each_line.map { |l| l.split.first.to_i }.sort
rights = elf_inputs.each_line.map { |l| l.split.last.to_i }.sort

left_test = elf_inputs_test.each_line.map { |l| l.split.first.to_i }.sort
right_test = elf_inputs_test.each_line.map { |l| l.split.last.to_i }.sort

def find_distance(lefts, rights)
  lefts.each_with_index.map { |location_id, i| (location_id - rights[i]).abs }.sum
end

puts "Solution One TEST = #{find_distance(left_test, right_test)}"
puts "Solution One = #{find_distance(lefts, rights)}"

# Solution part two

def find_frequency(lefts, rights)
  lefts.map { |location_id| rights.count(location_id) * location_id }.sum
end

puts "Solution Two TEST = #{find_frequency(left_test, right_test)}"
puts "Solution Two = #{find_frequency(lefts, rights)}"