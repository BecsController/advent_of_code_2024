require "pry"
# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

DIRECTIONS = {
  "^": [-1, 0],
  ">": [0, 1],
  "<": [0, -1],
  "v": [1, 0],
}

map, movements = elf_inputs.split("\n\n")
map = map.split("\n").map(&:chars)
movements = movements.split("\n").join.chars
@current_position = map.each_with_index.with_object([]) do |(line, y), obj|
  line.each_with_index { |char, x| obj << [y, x] if char == "@" }
end.flatten

map[@current_position[0]][@current_position[1]] = "."

movements.each do |move|
  current_y, current_x = @current_position

  next_x = current_x + DIRECTIONS[move.to_sym][1]
  next_y = current_y + DIRECTIONS[move.to_sym][0]

  case map[next_y][next_x]
  when "#"
    next
  when "."
    @current_position = [next_y, next_x]
  else
    if move == ">"
      first_part_of_row = map[next_y].slice(0...next_x)
      rest_of_row = map[next_y].slice(next_x..-1)
      next_space = rest_of_row.index(".")

      next unless next_space
      next if rest_of_row.include?("#") && rest_of_row.index("#") < next_space

      map[next_y][first_part_of_row.count + next_space] = "O"
      map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    elsif move == "<"
      first_part_of_row = map[next_y].slice(0..next_x)
      next_space = first_part_of_row.rindex(".")

      next unless next_space
      next if first_part_of_row.include?("#") && first_part_of_row.rindex("#") > next_space

      map[next_y][next_space] = "O"
      map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    elsif move == "v"
      first_part_of_row = map.transpose[next_x].slice(0...next_y)
      rest_of_row = map.transpose[next_x].slice(next_y..-1)
      next_space = rest_of_row.index(".")

      next unless next_space
      next if rest_of_row.include?("#") && rest_of_row.index("#") < next_space

      map[first_part_of_row.count + next_space][next_x] = "O"
      map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    else
      first_part_of_row = map.transpose[next_x].slice(0..next_y)
      rest_of_row = map.transpose[next_x].slice(next_y+1..-1)
      next_space = first_part_of_row.rindex(".")

      next unless next_space
      next if first_part_of_row.include?("#") && first_part_of_row.rindex("#") > next_space

      map[next_space][next_x] = "O"
      map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    end
  end
end

all_box_positions = map.each_with_index.with_object([]) do |(line, y), obj|
  line.each_with_index { |char, x| obj << [y, x] if char == "O" }
end

sum_of_gps = all_box_positions.sum do |coords|
  y, x = coords
  (y * 100) + x
end

puts "Solution One = #{sum_of_gps}"

# Solution part two

map, movements = elf_inputs_test.split("\n\n")
map = map.split("\n").map(&:chars)

def increase_map(map)
  map.map do |line|
    new_line = []
    line.each do |char|
      case char
      when "#"
        2.times { new_line << "#" }
      when "O"
        new_line << "["
        new_line << "]"
      when "."
        2.times { new_line << "." }
      when "@"
        new_line << "@"
        new_line << "."
      end
    end
    new_line
  end
end

new_map = increase_map(map)

movements = movements.split("\n").join.chars
@current_position = new_map.each_with_index.with_object([]) do |(line, y), obj|
  line.each_with_index { |char, x| obj << [y, x] if char == "@" }
end.flatten
binding.pry
new_map[@current_position[0]][@current_position[1]] = "."

movements.each do |move|
  current_y, current_x = @current_position

  next_x = current_x + DIRECTIONS[move.to_sym][1]
  next_y = current_y + DIRECTIONS[move.to_sym][0]

  case new_map[next_y][next_x]
  when "#"
    next
  when "."
    @current_position = [next_y, next_x]
  else
    if move == ">"
      first_part_of_row = new_map[next_y].slice(0...next_x)
      rest_of_row = new_map[next_y].slice(next_x..-1)
      next_space = rest_of_row.index(".")
      binding.pry
      next unless next_space
      next if rest_of_row.include?("#") && rest_of_row.index("#") < next_space

      new_map[next_y][first_part_of_row.count + next_space] = "O"
      new_map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    elsif move == "<"
      first_part_of_row = new_map[next_y].slice(0..next_x)
      next_space = first_part_of_row.rindex(".")

      next unless next_space
      next if first_part_of_row.include?("#") && first_part_of_row.rindex("#") > next_space

      first_part_of_row = new_map[next_y].slice(0...next_space)
      next_bit = new_map[next_y].slice(next_space+1...current_x)
      rest_of_row = new_map[next_y].slice(current_x..-1)
      binding.pry
      new_map[next_y] = [first_part_of_row, next_bit, ['.'], rest_of_row].flatten
      @current_position = [next_y, next_x]
    elsif move == "v"
      first_part_of_row = new_map.transpose[next_x].slice(0...next_y)
      rest_of_row = new_map.transpose[next_x].slice(next_y..-1)
      next_space = rest_of_row.index(".")
      binding.pry
      next unless next_space
      next if rest_of_row.include?("#") && rest_of_row.index("#") < next_space

      new_map[first_part_of_row.count + next_space][next_x] = "O"
      new_map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    else
      first_part_of_row = new_map.transpose[next_x].slice(0..next_y)
      rest_of_row = new_map.transpose[next_x].slice(next_y+1..-1)
      next_space = first_part_of_row.rindex(".")

      next unless next_space
      next if first_part_of_row.include?("#") && first_part_of_row.rindex("#") > next_space
      binding.pry
      new_map[next_space][next_x] = "O"
      new_map[next_y][next_x] = "."
      @current_position = [next_y, next_x]
    end
  end
end

all_box_positions = new_map.each_with_index.with_object([]) do |(line, y), obj|
  line.each_with_index { |char, x| obj << [y, x] if char == "[" }
end

sum_of_gps = all_box_positions.sum do |coords|
  y, x = coords
  (y * 100) + x
end