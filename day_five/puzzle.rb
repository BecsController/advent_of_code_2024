require "pry"

# Solution part one

elf_inputs_test = File.open("test_input.txt").read
elf_inputs = File.open("input.txt").read

page_ordering, page_numbers = elf_inputs.split("\n\n")
@rules = page_ordering.split("\n").map{|rule| rule.split("|") }
page_numbers = page_numbers.split("\n").map{|line| line.split(",")}

@incorrect_pages = []
@middle_numbers = []

def check_rules(number, page)  
  @rules.map do |rule|
    first, second = rule

    if page.index(first).nil? || page.index(second).nil?
      true
    else
      page.index(first) < page.index(second)
    end
  end
end

def check_pages(pages)
  pages.each do |page|
    correct = page.map do |num| 
      results = check_rules(num, page)
      results.all?(true)
    end

    if correct.all?(true)
      @middle_numbers << page[page.count/2].to_i
    else
      @incorrect_pages << page
    end
  end
end

check_pages(page_numbers)

puts "Solution One = #{@middle_numbers.sum}"

# Solution part two

@corrected_middle_numbers = []

def fix_wrong_numbers(page)
  @rules.each do |rule|
    first, second = rule

    if page.index(first) && page.index(second) && page.index(first) > page.index(second)
      new_page = page.dup

      first_index = new_page.index(first)
      second_index = new_page.index(second)

      new_page[second_index] = first
      new_page[first_index] = second

      return fix_wrong_numbers(new_page)
    end
  end

  page
end

def correct_pages
  @incorrect_pages.each do |page|
    new_page = fix_wrong_numbers(page)

    @corrected_middle_numbers << new_page[new_page.count/2].to_i
  end
end

correct_pages

puts "Solution Two = #{@corrected_middle_numbers.sum}"