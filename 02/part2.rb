#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

powers = input.map do |line|
  game_match = line.match(/\AGame (\d+):/)

  power = {
    red: 0,
    green: 0,
    blue: 0
  }

  line.gsub(game_match[0], '').split(';').each do |move|
    move.split(',').each do |cube|
      match = cube.match(/(\d+) ([a-z]+)/)
      color = match[2].to_sym
      power[color] = [power[color], match[1].to_i].max
    end
  end

  power
end

puts "Powers: #{powers.inspect}"

puts "Answer: #{powers.map { |p| p.values.inject(:*) }.sum}"
