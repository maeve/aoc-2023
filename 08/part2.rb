#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Node
  attr_reader :code
  attr_accessor :left, :right

  def initialize(code:)
    @code = code
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

count = 0
current_nodes = nodes.values.select { |node| node.code.end_with?('A') }

until current_nodes.all?(&:finish?)
  move = instructions.shift
  current_nodes = move == 'L' ? current_nodes.map(&:left) : current_nodes.map(&:right)
  instructions.push(move)
  count += 1
end

puts "Answer: #{count}"
