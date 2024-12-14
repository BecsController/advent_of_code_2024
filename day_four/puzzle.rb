require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

diagonal_matrix = []

@matrix = elf_inputs.split("\n").map { |l| l.chars }
FORWARD = "XMAS"
BACKWARD = "SAMX"

def left_diagonal_matrix
  n = @matrix.count
  m = @matrix.first.count
  counter = 0
  lines = []
  while (counter < 2 * n-1) do
    current = []
    Array(0...m).each do |i|
      Array(0...n).each do |j|
        current.append(@matrix[i][j]) if i + j == counter
      end
    end
    lines << current
    counter += 1
  end
  lines
end

left_diagonals = left_diagonal_matrix.map(&:join)

def right_diagonal_matrix
  n = @matrix.count
  m = @matrix.first.count
  counter = 2 * n - 1
  lines = []
  while (counter > 0) do
    current = []
    Array(0...m).each do |i|
      Array(0...n).reverse.each do |j|
        current.append(@matrix[i][j]) if (i + n - j) == counter
      end
    end
    lines << current
    counter -= 1
  end
  lines
end

right_diagonals = right_diagonal_matrix.map(&:join)

horizontal = @matrix.map(&:join).sum{ |l| l.scan(FORWARD).count + l.scan(BACKWARD).count}
vertical = @matrix.transpose.map(&:join).sum{ |l| l.scan(FORWARD).count + l.scan(BACKWARD).count}
diag_left = left_diagonals.sum{ |l| l.scan(FORWARD).count + l.scan(BACKWARD).count}
diag_right = right_diagonals.sum{ |l| l.scan(FORWARD).count + l.scan(BACKWARD).count}

result = [vertical, horizontal, diag_left, diag_right].sum

puts "Solution One = #{result}"

# Solution part two

@x_mas_count = 0

def on_edge?(x, y)
  y == 0 || y == @matrix.count - 1 || x == 0 || x == @matrix.count - 1
end

def check_corners(x, y)
  return false if on_edge?(x, y)

  left = @matrix[y - 1][x - 1]
  right = @matrix[y - 1][x + 1]
  bottom_left = @matrix[y + 1][x - 1]
  bottom_right = @matrix[y + 1][x + 1]

  [bottom_left, right].sort.join == "MS" && [bottom_right, left].sort.join == "MS"
end

def find_middles
  @matrix.each_with_index do |line, i|
    line.each_with_index do |position, j|
      next unless position == "A"

      @x_mas_count += 1 if check_corners(j, i)
    end
  end
end

find_middles

puts "Solution Two = #{@x_mas_count}"