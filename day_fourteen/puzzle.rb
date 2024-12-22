require "pry"
require "matrix"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read.split("\n")
elf_inputs = File.open("input.txt").read.split("\n")

test_width = 11
test_height = 7

actual_width = 101
actual_height = 103

matrix = Array.new(actual_height) { Array.new(actual_width, 0) }
ROBOT_MAP = {}

def create_robot_map(elf_inputs)
  elf_inputs.each_with_index do |robot, index|
    p, v = robot.split(" ")
    x, y = p.delete("p=").split(",")
    vx, vy = v.delete("v=").split(",")
    ROBOT_MAP[index] = [Vector[x.to_i, y.to_i], Vector[vx.to_i, vy.to_i]]
  end
end

def move_robot(robot, matrix, i)
  position, velocity = ROBOT_MAP[robot]
  new_x = (position + velocity)[0]
  new_y = (position + velocity)[1]

  # teleport blocks
  if new_y.negative? && new_y.abs >= matrix.count
    new_y += matrix.count
  end

  if new_y >= matrix.count
    new_y -= matrix.count
  end

  if new_x >= matrix.first.count
    new_x -= matrix.first.count
  end

  if new_x.negative? && new_x.abs >= matrix.first.count
    new_x += matrix.first.count
  end

  ROBOT_MAP[robot] = [Vector[new_x, new_y], velocity]

  matrix[new_y][new_x] += 1 if i == 99
end

create_robot_map(elf_inputs)

100.times do |i|
  ROBOT_MAP.keys.each do |robot|
    move_robot(robot, matrix, i)
  end
end

top_half = matrix.slice(0..(matrix.count / 2 -1))
bottom_half = matrix.slice((matrix.count / 2 + 1)..-1)

left_top_quadrant = top_half.map{ |line| line.slice(0..(line.count / 2 -1))}.flatten.sum
right_top_quadrant = top_half.map{ |line| line.slice((line.count / 2 + 1)..-1)}.flatten.sum

bottom_left_quadrant = bottom_half.map{ |line| line.slice(0..(line.count / 2 -1))}.flatten.sum
bottom_right_quadrant = bottom_half.map{ |line| line.slice((line.count / 2 + 1)..-1)}.flatten.sum


total_safety_factor = left_top_quadrant * right_top_quadrant * bottom_left_quadrant * bottom_right_quadrant

puts "Solution One = #{total_safety_factor}"

# Solution part two

second_matrix = Array.new(actual_height) { Array.new(actual_width, 0) }
ROBOT_MAP_TWO = {}

def create_robot_map_two(elf_inputs)
  elf_inputs.each_with_index do |robot, index|
    p, v = robot.split(" ")
    x, y = p.delete("p=").split(",")
    vx, vy = v.delete("v=").split(",")
    ROBOT_MAP_TWO[index] = [Vector[x.to_i, y.to_i], Vector[vx.to_i, vy.to_i]]
  end
end

def position_robot(robot, second_matrix)
  position, _velocity = ROBOT_MAP_TWO[robot]
  x = position[0]
  y = position[1]

  second_matrix[y][x] += 1
end

def move_robot_and_print(robot, second_matrix, i)
  position, velocity = ROBOT_MAP_TWO[robot]
  new_x = (position + velocity)[0]
  new_y = (position + velocity)[1]

  second_matrix[position[1]][position[0]] -= 1
  # teleport blocks
  if new_y.negative? && new_y.abs >= second_matrix.count
    new_y += second_matrix.count
  end

  if new_y >= second_matrix.count
    new_y -= second_matrix.count
  end

  if new_x >= second_matrix.first.count
    new_x -= second_matrix.first.count
  end

  if new_x.negative? && new_x.abs >= second_matrix.first.count
    new_x += second_matrix.first.count
  end

  ROBOT_MAP_TWO[robot] = [Vector[new_x, new_y], velocity]
  binding.pry if second_matrix[new_y].nil?
  second_matrix[new_y][new_x] += 1
end

create_robot_map_two(elf_inputs)

ROBOT_MAP_TWO.keys.each { |robot| position_robot(robot, second_matrix) }

def print_matrix(second_matrix, i)
  puts "iteration count is #{i + 1}"
  second_matrix.each do |line|
    print line.map { |ch| ch.zero? ? "." : "|"}.join
    puts ""
  end
end

def highest_consecutive_robots(line)
  line.chunk { |x| x == "|" || nil }.map { |_, x| x.size }.max || 0
end

200_000.times do |i|
  ROBOT_MAP_TWO.keys.each do |robot|
    move_robot_and_print(robot, second_matrix, i)
  end

  changed_matrix = second_matrix.map { |line| line.map { |ch| ch.zero? ? "." : "|"}}
  print_matrix(second_matrix, i) if changed_matrix.any?  { |line| highest_consecutive_robots(line) > 9 }
  break if changed_matrix.any?  { |line| highest_consecutive_robots(line) > 9 }
end 

