#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

total_cubes = {
  red: 12,
  green: 13,
  blue: 14
}

possible_game_ids = []

input.each do |line|
  game_match = line.match(/\AGame (\d+):/)

  game_id = game_match[1].to_i

  puts "Line: #{line}"
  puts "Game ID:  #{game_id}"

  moves = line.gsub(game_match[0], '').split(';').map do |move|
    cubes = {}

    move.split(',').each do |cube|
      match = cube.match(/(\d+) ([a-z]+)/)
      cubes[match[2].to_sym] = match[1].to_i
    end

    cubes
  end
  puts "moves: #{moves.inspect}"

  next unless moves.all? do |move|
    move.all? do |color, count|
      count <= total_cubes[color]
    end
  end

  possible_game_ids << game_id
end

puts "Possible Game IDs: #{possible_game_ids.inspect}"
puts "Answer: #{possible_game_ids.sum}"
