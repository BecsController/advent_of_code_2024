require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

def get_combo_operand(operand, registers)
  return operand if (0..3).to_a.include?(operand)

  case operand
  when 4
    return registers[:A]
  when 5
    return registers[:B]
  when 6
    return registers[:C]
  else
    raise "WHAT"
  end
end

def call_program(opcode, operand, registers)
  case opcode
  when 0
    registers[:A] = registers[:A] / (2 ** get_combo_operand(operand, registers))
  when 1
    registers[:B] ^= operand
  when 2
    registers[:B] = get_combo_operand(operand, registers) % 8 
  when 3
    return if registers[:A].zero?
  
    @instruction_pointer = operand - 2
  when 4
    registers[:B] ^= registers[:C]
  when 5
    get_combo_operand(operand, registers) % 8
  when 6
    registers[:B] = registers[:A] / (2 ** get_combo_operand(operand, registers))
  when 7
    registers[:C] = registers[:A] / (2 ** get_combo_operand(operand, registers))
  end
end

@output = []
@instruction_pointer = 0
program = elf_inputs.split("\n\n").last.delete("Program: ").split(",").map(&:to_i)

registers = elf_inputs.split("\n\n").first.split("\n").each.with_object({}) do |register_str, obj|
  letter = register_str.scan(/[A-C]/).first
  obj[letter.to_sym] = register_str.scan(/\d/).join.to_i
end

def start_program(program, registers)
  @instruction_pointer = 0
  @output = []
  while @instruction_pointer < program.length
    opcode = program[@instruction_pointer]
    operand = program[@instruction_pointer + 1]

    result = call_program(opcode, operand, registers)
    @output << result if opcode == 5

    @instruction_pointer += 2
  end

  @output
end

output = start_program(program, registers)

puts "Solution One = #{@output.join(",")}"

# Solution part two
rolling_value = 36090357560398
# Using this to narrow it down with larger => smaller increments

while @output != program
  rolling_value += 1000
  registers[:A] = rolling_value
  registers[:B] = 0
  registers[:C] = 0

  print registers[:A]
  puts ""
  @output = start_program(program, registers)
  print @output
  puts ""
  print @output.count
  break if @output.slice(0..11) == [2,4,1,5,7,5,1,6,0,3,4,1]
  break if @output.count == 17
  puts ""
end 

# puts "Solution Two = #{@corrected_middle_numbers.sum}"