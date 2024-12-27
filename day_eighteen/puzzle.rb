require "pry"
require "matrix"
require 'pqueue'

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

height = 70
@number_to_fall = 1024
DOWN = Vector[1,0]
UP = Vector[-1,0]
LEFT = Vector[0,-1]
RIGHT = Vector[0,1]

start_position = Vector[0, 0]
exit_position = Vector[height, height]
bytes = elf_inputs.split("\n").slice(0..@number_to_fall-1)
corrupted_bytes = bytes.map { |byte| x, y = byte.split(","); Vector[x.to_i, y.to_i]}

def find_shortest_path(corrupted_bytes, start_position, exit_position)
  priority_queue = PQueue.new([[0, start_position]]) { |a, b| a[0] <=> b[0] }
  visited = Set.new

  until priority_queue.empty?
    step, current_position = priority_queue.shift

    next if visited.include?(current_position) || corrupted_bytes.include?(current_position)
    visited << current_position

    if current_position == exit_position
      return step
    else
      [UP, DOWN, LEFT, RIGHT].each do |direction|
        new_position = current_position + direction

        next unless (new_position[0] >= start_position[0] && new_position[0] <= exit_position[0] && new_position[1] >= start_position[1] && new_position[1] <= exit_position[1])

        next if(corrupted_bytes.include?(new_position) || visited.include?(new_position))
        priority_queue << [step + 1, new_position]
      end
    end
  end

  return nil
end

number_of_steps = find_shortest_path(corrupted_bytes, start_position, exit_position)

puts "Solution One = #{number_of_steps}"

# Solution part two

total_bytes = elf_inputs.split("\n")
path = nil

total_corrupted_bytes = total_bytes.map { |byte| x, y = byte.split(","); Vector[x.to_i, y.to_i]}
bytes_removed = 0

while path.nil? do
  path = find_shortest_path(total_corrupted_bytes, start_position, exit_position)

  unless path
    total_corrupted_bytes.pop
    bytes_removed += 1
  end
end

puts "Solution Two = #{total_bytes[-bytes_removed]}"

