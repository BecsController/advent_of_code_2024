require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

disk_map = elf_inputs.chars.each_with_index.map do |char, i|
  if i % 2 == 0
    (i / 2).to_s * char.to_i
  else
    "." * char.to_i
  end
end.join.chars


reverse_map = disk_map.reverse
reverse_map.each_with_index do |char, i|
  moving = char
  next_free_space = disk_map.index(".")
  # break if i ==
  break if disk_map.slice(next_free_space..disk_map.length-1).none? { |d| d.match(/\d/)}
  disk_map[next_free_space] = moving
  disk_map[disk_map.length - 1 - i] = "."
end

# disk_map = stuff_the_thing_up(start_map)
disk_map.delete(".")
checksum = disk_map.each_with_index.sum do |d, i| 
  d.to_i * i
end

puts "Solution One = #{checksum}"

# Solution part two

# puts "Solution Two = #{@corrected_middle_numbers.sum}"

# "00...111...2...333.44.5555.6666.777.888899"