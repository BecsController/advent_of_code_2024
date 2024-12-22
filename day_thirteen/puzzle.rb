require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read.split("\n\n")
elf_inputs = File.open("input.txt").read.split("\n\n")

BUTTON_COST = {
  "A": 3, 
  "B": 1
}

machines = elf_inputs_test.map{ |m| m.split("\n") }

class Machine
  attr_reader :prize_x, :prize_y, :button_a_x, :button_a_y, :button_b_x, :button_b_y

  def initialize(machine)
    button_a, button_b, prize = machine
    prize_x, prize_y = prize.split(",")
    @prize_x = prize_x.gsub(/\D/, "").to_i
    @prize_y = prize_y.gsub(/\D/, "").to_i

    button_ax, button_ay = button_a.split(",")
    @button_a_x = button_ax.gsub(/\D/, "").to_i
    @button_a_y = button_ay.gsub(/\D/, "").to_i

    button_bx, button_by = button_b.split(",")
    @button_b_x = button_bx.gsub(/\D/, "").to_i
    @button_b_y = button_by.gsub(/\D/, "").to_i
  end

  def find_button_presses
    # b=(py*ax-px*ay)/(by*ax-bx*ay) a=(px-b*bx)/ax https://www.reddit.com/r/adventofcode/comments/1hd5b6o/2024_day_13_in_the_end_math_reigns_supreme/
    b = (prize_y*button_a_x-prize_x*button_a_y)/(button_b_y*button_a_x-button_b_x*button_a_y) 
    a = (prize_x-b*button_b_x)/button_a_x

    [a, b]
  end

  def total_cost
    a_presses, b_presses = find_button_presses
    print BUTTON_COST[:A] * a_presses
    puts ""
    print BUTTON_COST[:B] * b_presses
    binding.pry if prize_x == 7870 || prize_x == 18641
    (BUTTON_COST[:A] * a_presses) + (BUTTON_COST[:B] * b_presses)
  end
end

cost_for_all_prizes = machines.sum do |machine|
  machine = Machine.new(machine)
  machine.total_cost
end

puts "Solution One = #{cost_for_all_prizes}"

# Solution part two

# puts "Solution Two = #{@corrected_middle_numbers.sum}"
