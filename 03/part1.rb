#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

schematic = input.map(&:chars)

sum_parts = 0

schematic.each_index do |row|
  part_number = ''
  has_adjacent_symbol = false

  schematic[row].each_index do |col|
    if schematic[row][col] =~ /[0-9]/
      part_number += schematic[row][col]

      unless has_adjacent_symbol
        min_row = row.zero? ? row : row - 1
        max_row = row == schematic.length - 1 ? row : row + 1
        min_col = col.zero? ? col : col - 1
        max_col = col == schematic[row].length - 1 ? col : col + 1

        has_adjacent_symbol = (min_row..max_row).any? do |r|
          (min_col..max_col).any? do |c|
            schematic[r][c] =~ /[^0-9.]/
          end
        end
      end

      if col == schematic[row].length - 1 || schematic[row][col + 1] =~ /[^0-9]/
        sum_parts += part_number.to_i if has_adjacent_symbol
        has_adjacent_symbol = false
        part_number = ''
      end
    end
  end
end

puts "Answer: #{sum_parts}"
