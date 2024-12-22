require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read.split
elf_inputs = File.open("input.txt").read.split

MULT_BY = 2024
blink_count = 25
new_sequence = elf_inputs.group_by(&:itself).transform_values(&:count)

def blink(sequence)
  mem = Hash.new(0)
  sequence.each do |number, count|
    case
    when number.to_i.zero?
      mem["1"] += count
    when number.chars.count.even?
      half = number.chars.count / 2
      left = number.chars.take(half).join
      right = number.chars[half..number.chars.length - 1].join.to_i.to_s
      mem[left] += count
      mem[right] += count
    else
      mem[(number.to_i * MULT_BY).to_s] += count
    end
  end
  mem
end

while blink_count > 0
  new_sequence = blink(new_sequence)
  blink_count -= 1
end

puts "Solution One = #{new_sequence.values.sum}"

newer_sequence = elf_inputs.group_by(&:itself).transform_values(&:count)
blink_count = 75

while blink_count > 0
  newer_sequence = blink(newer_sequence)
  blink_count -= 1
end

puts "Solution Two = #{newer_sequence.values.sum}"
