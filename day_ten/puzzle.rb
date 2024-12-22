require "pry"
require "matrix"

# Solution part one
# Recursive functions dont return properly if they dont have a base method that isn't recursive

elf_inputs_test = File.open("test_input.txt").read.split("\n")
elf_inputs = File.open("input.txt").read.split("\n")
matrix = elf_inputs_test.map { |l| l.chars }

DOWN = Vector[1,0]
UP = Vector[-1,0]
LEFT = Vector[0,-1]
RIGHT = Vector[0,1]

class HoofIt
  attr_reader :coord_set

  def initialize(inputs)
    @coord_set = get_coords(inputs)
  end

  def check_for_path(current_coords, path_so_far)
    path_so_far << current_coords
    return 1 if coord_set[current_coords] == 9
    [DOWN, UP, LEFT, RIGHT].sum do |next_pos|
      next 0 if (coord_set[current_coords + next_pos] != coord_set[current_coords] + 1)
      return check_for_path(current_coords + next_pos, path_so_far)
    end
  end

  private

  def get_coords(elf_inputs)
    elf_inputs.each_with_index.with_object({}) { |(line, y), grid|
      line.chars.each_with_index { |char, x|
        grid[Vector[y, x]] = char.to_i
      }
    }
  end
end

hoof_it = HoofIt.new(elf_inputs_test)
result = hoof_it.coord_set.select { |k, v| v.zero? }.keys.sum do |coords| 
  hoof_it.check_for_path(coords, Set.new)
end
binding.pry

puts "Solution One = #{result}"

# Solution part two

# puts "Solution Two = #{@corrected_middle_numbers.sum}"