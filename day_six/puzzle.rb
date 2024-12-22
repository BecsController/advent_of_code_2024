require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read
matrix = elf_inputs_test.split("\n").map { |l| l.chars }

OBSTRUCTION = "#"
DIRECTION_CHANGES = {
  "^": ">",
  ">": "v",
  "v": "<",
  "<": "^"
}

@current_guard_direction = "^"
@loop_count = 0
@checking_for_loops = false

def check_direction(matrix)
  new_y, new_x = @new_coords

  if new_y.negative? || new_x.negative? || matrix[new_y].nil? || matrix[new_x].nil?
    return "EXIT"
  end

  new_position = matrix[new_y][new_x]

  if new_position == OBSTRUCTION
    "ROTATE"
  else
    "CONTINUE"
  end
end

def move(matrix)
  case @current_guard_direction
  when "^"
    @new_coords[0] -= 1
    check_direction(matrix)
  when "v"
    @new_coords[0] += 1
    check_direction(matrix)
  when ">"
    @new_coords[1] += 1
    check_direction(matrix)
  when "<"
    @new_coords[1] -= 1
    check_direction(matrix)
  end
end

def back_up_from_obstruction
  case @current_guard_direction
  when "^"
    @new_coords[0] += 1
  when "v"
    @new_coords[0] -= 1
  when ">"
    @new_coords[1] -= 1
  when "<"
    @new_coords[1] += 1
  end
end

def check_for_loop
  return false unless @coords_list.include?(@new_coords.join(","))
  binding.pry
  next_position_y, next_position_x = @new_coords
  case @current_guard_direction
  when "^"
    next_position_y += 1
  when "v"
    next_position_y -= 1
  when ">"
    next_position_x -= 1
  when "<"
    next_position_x += 1
  end
  binding.pry
  @coords_list.include?("#{next_position_y},#{next_position_x}")
end

def adjust_movement(matrix)
  new_action = move(matrix)

  case new_action
  when "EXIT"
    @final_count = @coords_list.uniq.count
  when "ROTATE"
    back_up_from_obstruction
    @current_guard_direction = DIRECTION_CHANGES[@current_guard_direction.to_sym]
    adjust_movement(matrix)
  when "CONTINUE"
    if @checking_for_loops && check_for_loop
      @loop_count += 1
      @coords_list = []
      raise
    else
      @coords_list << @new_coords.join(",")
      @current_guard_position = @new_coords
      adjust_movement(matrix)
    end
  end
end

@current_guard_position = matrix.each_with_index.with_object([]) do |(line, y), obj|
  line.each_with_index { |char, x| obj << [y, x] if char == "^" }
end.flatten

matrix[@current_guard_position[0]][@current_guard_position[1]] = "."
@new_coords = @current_guard_position
@coords_list = [@new_coords.join(",")]

adjust_movement(matrix)

puts "Solution One = #{@final_count}"

# Solution part two

@coords_list = []
@checking_for_loops = true

matrix.each_with_index do |line, i|
  line.each_with_index do |char, j|
    if char != "#"
      new_matrix = elf_inputs_test.split("\n").map { |l| l.chars }
      @current_guard_direction = "^"
      @current_guard_position = new_matrix.each_with_index.with_object([]) do |(line, y), obj|
        line.each_with_index { |char, x| obj << [y, x] if char == "^" }
      end.flatten
      new_matrix[@current_guard_position[0]][@current_guard_position[1]] = "."
      @new_coords = @current_guard_position

      new_matrix[i][j] = "#"
      @coords_list = [@new_coords.join(",")]

      begin
        adjust_movement(new_matrix)
      rescue
        binding.pry
      end
    end
  end
end

puts "Solution Two = #{@loop_count}"