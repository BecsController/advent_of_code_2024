require "pry"
require "matrix"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read.split("\n")
elf_inputs = File.open("input.txt").read.split("\n")

plots = elf_inputs_test.map(&:chars)
plants = elf_inputs_test.join.chars.uniq

DOWN = Vector[1,0]
UP = Vector[-1,0]
LEFT = Vector[0,-1]
RIGHT = Vector[0,1]

class Plot
  attr_reader :plant, :plant_coords

  def initialize(plant, coords)
    @plant = plant
    @plant_coords = coords
  end

  def count_neighbours(current)
    [DOWN, UP, LEFT, RIGHT].sum { |move| plant_coords.include?(move + current) ? 1 : 0 }
  end

  def perimeter
    binding.pry
    plant_coords.sum do |coord| 
      4 - count_neighbours(coord)
    end
  end

  def area
    plant_coords.count
  end

  def price
    area * perimeter
  end
end

class Garden
  def group_plants(garden)
    garden.each_with_index.with_object({}) { |(line, y), grid|
      line.chars.each_with_index { |char, x|
        grid[Vector[y, x]] = char
      }
    }.group_by do |vector|
      coords, plant = vector
      plant
    end.transform_values do |vectors|
      vectors.map(&:first)
    end
  end
end

grouped_plants = Garden.new.group_plants(elf_inputs_test)
binding.pry
fence_prices = grouped_plants.map do |plant_hash|
  plant, coords = plant_hash
  plant_plot = Plot.new(plant, coords)
  plant_plot.price
end

puts "Solution One = #{fence_prices.sum}"

# Solution part two

# puts "Solution Two = #{@corrected_middle_numbers.sum}"
