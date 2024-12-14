require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

@safe_report_count = 0

def convert_to_differences(line)
  line.each_with_index.map do |n, i|
    i == line.length - 1 ? nil : n - line[i + 1]
  end.compact
end

def safe_distance?(differences)
  differences = differences.map(&:abs)
  differences.none? { |d| d > 3 || d < 1 }
end

def safe_direction?(differences)
  differences.all?(&:positive?) || differences.all?(&:negative?)
end

def meets_regulations?(diffs)
  safe_distance?(diffs) && safe_direction?(diffs)
end

def check_safe_count_increment(inputs)
  inputs.each_line.map do |line|
    int_line = line.split.map(&:to_i)
    differences = convert_to_differences(int_line)

    @safe_report_count += 1 if meets_regulations?(differences)
  end
end

check_safe_count_increment(elf_inputs)

puts "Solution One = #{@safe_report_count}"

# Solution part two

@dampner_safe_report_count = 0

def total_result(line)
  (0..line.count - 1).to_a.map do |i|
    new_line = line.reject.with_index{ |d, idx| idx == i }
    differences = convert_to_differences(new_line)
    meets_regulations?(differences)
  end
end


def check_safe_count_with_dampener(inputs)
  inputs.each_line.map do |line|
    int_line = line.split.map(&:to_i)
    differences = convert_to_differences(int_line)

    if meets_regulations?(differences)
      @dampner_safe_report_count += 1 
      next
    else
      @dampner_safe_report_count += 1 if total_result(int_line).any?(true)
    end
  end
end

check_safe_count_with_dampener(elf_inputs)

puts "Solution Two = #{@dampner_safe_report_count}"