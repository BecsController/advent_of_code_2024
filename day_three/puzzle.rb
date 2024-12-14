require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

regexp = /mul\(\d+,\d+\)/
multiplications = elf_inputs.scan(regexp)

def mul(set)
  x, y = set.scan(/\d+,\d+/)[0].split(",").map(&:to_i)
  x * y
end

result = multiplications.map { |set| mul(set) }.sum

puts "Solution One = #{result}"

# Solution part two

enabled = true
instruct_regexp = /do\(\)|don't\(\)|mul\(\d+,\d+\)/
DISABLE = "don't()"
ENABLE = 'do()'
total = []

sets_of_instructions = elf_inputs.scan(instruct_regexp) do |set|
  case set
  when DISABLE
    enabled = false
  when ENABLE
    enabled = true
  else
    total << mul(set) if enabled
  end
end

puts "Solution Two = #{total.sum}"