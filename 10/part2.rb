#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Map
  attr_accessor :grid, :start

  def initialize(input)
    self.grid = Array.new(input.length) { Array.new(input.first.length) }

    input.each_with_index do |line, row|
      line.chars.each_with_index do |char, col|
        grid[row][col] = Tile.new(row: row, col: col, char: char)
      end
    end

    connect_tiles
  end

  def pipe_loop
    return @pipe_loop if @pipe_loop

    @pipe_loop = [start]

    loop do
      current = @pipe_loop.last

      current.next_tile = 
        if current.north && !@pipe_loop.include?(current.north)
          current.north
        elsif current.south && !@pipe_loop.include?(current.south)
          current.south
        elsif current.east && !@pipe_loop.include?(current.east)
          current.east
        elsif current.west && !@pipe_loop.include?(current.west)
          current.west
        end

      break unless current.next_tile && !current.next_tile.start?

      @pipe_loop << current.next_tile
    end

    # Zero out everything that is not loop
    grid.each do |row|
      row.each do |tile|
        tile.mark_ground unless @pipe_loop.include?(tile)
      end
    end

    @pipe_loop.last.next_tile = start
    start.replace_pipe

    @pipe_loop
  end

  def farthest_point
    pipe_loop.length / 2
  end

  def inside_tiles
    return @inside_tiles if @inside_tiles

    mark_tiles

    left_tiles = grid.flatten.select(&:left?)
    right_tiles = grid.flatten.select(&:right?)

    @inside_tiles = 
      if left_tiles.length > right_tiles.length
        left_tiles.each(&:mark_ground)
        right_tiles.length
      else
        right_tiles.each(&:mark_ground)
        left_tiles.length
      end
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

  def mark_sides(row, col, direction)
    current_row = row
    current_col = col

    case direction
    when :north
      until (current_col -= 1).negative?
        break if grid[row][current_col].pipe?

        grid[row][current_col].mark_left
      end

      current_col = col
      until (current_col += 1) == grid.first.length
        break if grid[row][current_col].pipe?

        grid[row][current_col].mark_right
      end
    when :south
      until (current_col -= 1).negative? || grid[row][current_col].pipe?
        grid[row][current_col].mark_right
      end

      current_col = col
      until (current_col += 1) == grid.first.length || grid[row][current_col].pipe?
        grid[row][current_col].mark_left
      end
    when :east
      until (current_row -= 1).negative? || grid[current_row][col].pipe?
        grid[current_row][col].mark_left
      end

      current_row = row
      until (current_row += 1) == grid.length || grid[current_row][col].pipe?
        grid[current_row][col].mark_right
      end
    when :west
      until (current_row -= 1).negative? || grid[current_row][col].pipe?
        grid[current_row][col].mark_right
      end

      current_row = row
      until (current_row += 1) == grid.length || grid[current_row][col].pipe?
        grid[current_row][col].mark_left
      end
    end
  end

  def mark_tiles
    pipe_loop.each do |tile|
      case tile.next_tile
      when tile.north
        mark_sides(tile.row, tile.col, :north)

        if tile.char == 'L'
          mark_sides(tile.row, tile.col, :west)
        elsif tile.char == 'J'
          mark_sides(tile.row, tile.col, :east)
        end
      when tile.south
        mark_sides(tile.row, tile.col, :south)

        if tile.char == 'F'
          mark_sides(tile.row, tile.col, :west)
        elsif tile.char == '7'
          mark_sides(tile.row, tile.col, :east)
        end
      when tile.east
        mark_sides(tile.row, tile.col, :east)

        if tile.char == 'L'
          mark_sides(tile.row, tile.col, :south)
        elsif tile.char == 'F'
          mark_sides(tile.row, tile.col, :north)
        end
      when tile.west
        mark_sides(tile.row, tile.col, :west)

        if tile.char == 'J'
          mark_sides(tile.row, tile.col, :south)
        elsif tile.char == '7'
          mark_sides(tile.row, tile.col, :north)
        end
      end
    end
  end

  def to_s
    grid.map do |row|
      row.map(&:char).join
    end.join("\n")
  end

  class Tile
    attr_accessor :char, :next_tile
    attr_reader :row, :col, :north, :south, :east, :west

    def initialize(row:, col:, char:)
      @row = row
      @col = col
      self.char = char
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

    def pipe?
      %w[S - J 7 L F |].include?(char)
    end

    def mark_left
      self.char = '#' unless pipe?
    end

    def mark_right
      self.char = '&' unless pipe?
    end

    def mark_ground
      self.char = '.'
    end

    def left?
      char == '#'
    end

    def right?
      char == '&'
    end

    def replace_pipe
      if north&.pipe? && south&.pipe?
        self.char = '|'
      elsif east&.pipe? && west&.pipe?
        self.char = '-'
      elsif north&.pipe? && east&.pipe?
        self.char = 'L'
      elsif north&.pipe? && west&.pipe?
        self.char = 'J'
      elsif south&.pipe? && east&.pipe?
        self.char = 'F'
      elsif south&.pipe? && west&.pipe?
        self.char = '7'
      end
    end
  end
end

map = Map.new(input)
puts "Answer: #{map.inside_tiles}"
puts "Map after finding loop:\n#{map}"
