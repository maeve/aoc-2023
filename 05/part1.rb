#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./test-input.txt').map(&:chomp)

require 'pry-byebug'

class Seed
  attr_accessor :seed, :soil, :fertilizer, :water, :light, :temperature, :humidity, :location

  def initialize(seed)
    self.seed = seed
    self.soil = seed
    self.fertilizer = seed
    self.water = seed
    self.light = seed
    self.temperature = seed
    self.humidity = seed
    self.location = seed
  end

  def to_s
    "Seed #{seed}, soil #{soil}, fertilizer #{fertilizer}, water #{water}, light #{light}, temperature #{temperature}, humidity #{humidity}, location #{location}"
  end
end

seed_line = input.shift
seeds = seed_line.gsub(/seeds: /, '').split(' ').compact.map { |seed| Seed.new(seed.to_i) }

maps = []

until input.empty?
  binding.pry
  input.shift
  match = input.shift.match(/(?<source>[a-z]+)-to-(?<destination>[a-z]+) map:/)
  source_name = match[:source]
  destination_name = match[:destination]

  until input.first.to_s.strip == ""
    destination_start, source_start, range_length = input.shift.split(' ').map(&:to_i)

    source_values = Range.new(source_start, source_start + range_length, true).to_a
    destination_values = Range.new(destination_start, destination_start + range_length, true).to_a

    value_map = source_values.zip(destination_values).to_h

    value_map.each_key do |key|
      source_seeds = seeds.group_by(&source_name.to_sym)[key] 
      source_seeds&.each do |seed|
        seed.send("#{destination_name}=", value_map[key])
      end
    end
  end
end

puts "Seeds: "
puts seeds.map(&:to_s).join("\n")
