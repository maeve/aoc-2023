#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Map
  attr_accessor :grid, :start

  def initialize(input)
    self.grid = input.map do |tile|
      tile.chars.map { |char| Tile.new(char) }
    end

    connect_tiles
  end

  def loop_length
    return @loop_length if @loop_length

    visited = [start]
    current = start

    loop do
      current = 
        if current.north && !visited.include?(current.north)
          current.north
        elsif current.south && !visited.include?(current.south)
          current.south
        elsif current.east && !visited.include?(current.east)
          current.east
        elsif current.west && !visited.include?(current.west)
          current.west
        end

      break if current.nil? || current.start?

      visited << current
    end

    @loop_length = visited.length
  end

  def farthest_point
    loop_length / 2
  end

  private

  def connect_tiles
    grid.each_with_index do |array, row|
      array.each_with_index do |tile, col|
        tile.north = grid[row - 1][col] if row.positive?
        tile.south = grid[row + 1][col] if row < grid.size - 1
        tile.east = grid[row][col + 1] if col < grid[row].size - 1
        tile.west = grid[row][col - 1] if col.positive?
        self.start = tile if tile.start?
      end
    end
  end

  class Tile
    attr_reader :char, :north, :south, :east, :west

    def initialize(char)
      @char = char
    end

    def north=(other_tile)
      @north = other_tile if %w[S | L J].include?(char) && %w[S | 7 F].include?(other_tile.char)
    end

    def south=(other_tile)
      @south = other_tile if %w[S | 7 F].include?(char) && %w[S | L J].include?(other_tile.char)
    end

    def east=(other_tile)
      @east = other_tile if %w[S - L F].include?(char) && %w[S - J 7].include?(other_tile.char)
    end

    def west=(other_tile)
      @west = other_tile if %w[S - J 7].include?(char) && %w[S - L F].include?(other_tile.char)
    end

    def start?
      char == 'S'
    end
  end
end

map = Map.new(input)
puts "Answer: #{map.farthest_point}"
