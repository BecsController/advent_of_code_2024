require "pry"
require "matrix"
# Solution part one

elf_inputs_test = File.open("test_input.txt").read.split("\n")
elf_inputs = File.open("input.txt").read.split("\n")
matrix = elf_inputs_test.map { |l| l.chars }
@total_nefarity = 0
ANTENNAS = Hash.new

matrix.each_with_index do |line, y|
  line.each_with_index do |char, x|
    unless ANTENNAS[char] || char == "."
      ANTENNAS[char] = []
    end
    ANTENNAS[char] << [x, y] if char != "."
  end
end

def off_map?(coords, matrix)
  x, y = coords

  return true if x >= matrix.first.count
  return true if y >= matrix.count

  x.negative? || y.negative?
end

def where_could_we_be_nefarious(matrix)
  ANTENNAS.each do |name, locations|
    locations.combination(2) do |combo|
      first, second = combo
      v1 = Vector[first[0], first[1]]
      v2 = Vector[second[0], second[1]]
      distance = (v1 - v2)

      potential_antinode_1 = [first[0] + distance[0] , first[1] + distance[1]] 

      unless off_map?(potential_antinode_1, matrix)
        unless matrix[potential_antinode_1[1]][potential_antinode_1[0]] == "#"
          matrix[potential_antinode_1[1]][potential_antinode_1[0]] = "#"
          @total_nefarity += 1
        end
      end

      potential_antinode_2 = [second[0] - distance[0] , second[1] - distance[1]]

      unless off_map?(potential_antinode_2, matrix)
        unless matrix[potential_antinode_2[1]][potential_antinode_2[0]] == "#"
          matrix[potential_antinode_2[1]][potential_antinode_2[0]] = "#"
          @total_nefarity += 1
        end
      end
    end
  end
end

where_could_we_be_nefarious(matrix)

puts "Solution One = #{@total_nefarity}"

# Solution part two

def where_else_we_be_nefarious
  ANTENNAS_TWO.each do |name, locations|
    locations.combination(2) do |combo|
      first, second = combo
      v1 = Vector[first[0], first[1]]
      v2 = Vector[second[0], second[1]]
      distance = (v1 - v2)

      while first do
        x, y = first
        @total_next_nefarity += 1 unless @matrix_two[y][x] == "#"
        @matrix_two[y][x] = "#"
        next_first = [x + distance[0], y + distance[1]] 
        break if off_map?(next_first, @matrix_two)
        @total_next_nefarity += 1 unless @matrix_two[next_first[1]][next_first[0]] == "#"
        @matrix_two[next_first[1]][next_first[0]] = "#"
        first = next_first
      end

      while second do
        x, y = second
        @total_next_nefarity += 1 unless @matrix_two[y][x] == "#"
        @matrix_two[y][x] = "#"
        next_second = [x + distance[0], y + distance[1]] 
        break if off_map?(next_second, @matrix_two)
        @total_next_nefarity += 1 unless @matrix_two[next_second[1]][next_second[0]] == "#"
        @matrix_two[next_second[1]][next_second[0]] = "#"
        second = next_second
      end
    end
  end
end

@total_next_nefarity = 0
ANTENNAS_TWO = Hash.new
@matrix_two = elf_inputs_test.map { |l| l.chars }

@matrix_two.each_with_index do |line, y|
  line.each_with_index do |char, x|
    unless ANTENNAS_TWO[char] || char == "."
      ANTENNAS_TWO[char] = []
    end
    ANTENNAS_TWO[char] << [x, y] if char != "."
  end
end

where_else_we_be_nefarious

puts "Solution Two = #{@total_next_nefarity}"