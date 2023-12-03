#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

schematic = input.map(&:chars)

gears = []
parts = []

class Part
  attr_accessor :min_row, :min_col, :max_row, :max_col

  def initialize
    @part_number = ''
  end

  def adjacent_to?(row, col)
    row.between?(min_row, max_row) && col.between?(min_col, max_col)
  end

  def append(number)
    @part_number += number
  end

  def part_number
    @part_number.to_i
  end
end

part = nil

schematic.each_index do |row|
  schematic[row].each_index do |col|
    if schematic[row][col] =~ /[0-9]/
      if part.nil?
        part = Part.new
        part.min_row = row.zero? ? row : row - 1
        part.min_col = col.zero? ? col : col - 1
      end

      part.append(schematic[row][col])

      if col == schematic[row].length - 1 || schematic[row][col + 1] =~ /[^0-9]/
        part.max_row = row == schematic.length - 1 ? row : row + 1
        part.max_col = col == schematic[row].length - 1 ? col : col + 1
        parts << part
        part = nil
      end
    elsif schematic[row][col] == '*'
      gears << [row, col]
    end
  end
end

gear_ratios = gears.map do |row, col|
  adjacent_parts = parts.select { |p| p.adjacent_to?(row, col) }

  if adjacent_parts.length != 2
    0
  else
    adjacent_parts.map(&:part_number).reduce(:*)
  end
end

puts "Answer: #{gear_ratios.sum}"
