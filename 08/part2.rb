#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Node
  attr_reader :code
  attr_accessor :left, :right

  def initialize(code:)
    @code = code
  end

  def start?
    code.end_with?('A')
  end

  def finish?
    code.end_with?('Z')
  end
end

nodes = {}

instructions = input.shift.chars
input.shift

while (node_line = input.shift)
  matches = node_line.match(/(?<code>[^ ]+) = \((?<left>[^,]+), (?<right>[^)]+)\)/)

  code = matches[:code]
  left = matches[:left]
  right = matches[:right]

  nodes[code] ||= Node.new(code: code)
  nodes[left] ||= Node.new(code: left)
  nodes[right] ||= Node.new(code: right)

  nodes[code].left = nodes[left]
  nodes[code].right = nodes[right]
end

current_nodes = nodes.values.select(&:start?)

cycles = current_nodes.map do |node|
  cycle = 0

  until node.finish?
    cycle += 1
    instructions.each do |move|
      if node.finish?
        break
      else
        node = move == 'L' ? node.left : node.right
      end
    end
  end

  cycle * instructions.length
end

count = cycles.reduce(1, :lcm)
puts "Answer: #{count}"
