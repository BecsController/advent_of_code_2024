require "pry"

# Solution part one

# repeats {"78"=>2, "1581"=>2}
elf_inputs_test = File.open("test_input.txt").read.split("\n")
elf_inputs = File.open("input.txt").read.split("\n")

results = []

def look_for_match(test_value, nums)
  operators = %w(+ * ||)
  operators.repeated_permutation(nums.length - 1).to_a.map do |combo|
    combined_arr = nums.zip(combo).flatten.compact
    evaluation = combined_arr.shift

    while combined_arr.length > 0 do
      next_operation = combined_arr.shift(2)

      if next_operation.include?("||")
        evaluation = evaluation.to_s.concat(next_operation.last.to_s).to_i
      else
        evaluation = eval(evaluation.to_s.concat(next_operation.join))
      end
    end

    return test_value if evaluation == test_value
  end
  false
end

elf_inputs.each do |line|
  test_value, numbers = line.split(":")
  nums = numbers.split.map(&:to_i)
  test_value = test_value.to_i

  match = look_for_match(test_value, nums)
  results.append(test_value) if match
end

puts "Solution One = #{results.sum}"

# Solution part two

# puts "Solution Two = #{@corrected_middle_numbers.sum}"