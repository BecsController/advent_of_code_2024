require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

base_index = 0
disk_map = []

elf_inputs.chars.each_with_index.map do |char, i|
  if i.even?
    disk_map << base_index.to_s * char.to_i
    base_index += 1
  else
    disk_map <<  "." * char.to_i
  end
end

disk_map = disk_map.join.chars
reverse_map = disk_map.reverse
reverse_map.each_with_index do |char, i|
  moving = char
  next_free_space = disk_map.index(".")
  # break if i ==
  break if disk_map.slice(next_free_space..disk_map.length-1).none? { |d| d.match(/\d/)}
  disk_map[next_free_space] = moving
  disk_map[disk_map.length - 1 - i] = "."
end

# disk_map.delete(".")

checksum = disk_map.each_with_index.sum do |d, i| 
  d.to_i * i
end

puts "Solution One = #{checksum}"

# Solution part two

# puts "Solution Two = #{@corrected_middle_numbers.sum}"

"00...111...2...333.44.5555.6666.777.888899"