#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Card
  attr_reader :id, :winning_numbers, :actual_numbers

  def initialize(input)
    matches = input.match(/Card +(?<id>\d+): (?<winning>[0-9 ]*) \| (?<actual>[0-9 ]*)/)
    @id = matches[:id].to_i
    @winning_numbers = matches[:winning].split(' ').compact.map(&:to_i)
    @actual_numbers = matches[:actual].split(' ').compact.map(&:to_i)
  end

  def points
    match_count = actual_numbers.intersection(winning_numbers).size

    if match_count.positive?
      2**(match_count - 1)
    else
      0
    end
  end
end

answer = input.map { |line| Card.new(line).points }.sum
puts "Answer: #{answer}"
