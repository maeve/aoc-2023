#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Seed
  attr_accessor :seed, :soil, :fertilizer, :water, :light, :temperature, :humidity, :location

  def initialize(seed)
    self.seed = seed
  end

  def to_s
    "Seed #{seed}, soil #{soil}, fertilizer #{fertilizer}, water #{water}, light #{light}, temperature #{temperature}, humidity #{humidity}, location #{location}"
  end
end

seed_line = input.shift
seeds = seed_line.gsub(/seeds: /, '').split(' ').compact.map { |seed| Seed.new(seed.to_i) }

until input.empty?
  input.shift
  match = input.shift.match(/(?<source>[a-z]+)-to-(?<destination>[a-z]+) map:/)
  source_name = match[:source]
  destination_name = match[:destination]

  source_seeds = seeds.group_by(&source_name.to_sym)

  until input.first.to_s.strip.empty?
    destination_start, source_start, range_length = input.shift.split(' ').map(&:to_i)

    source_values = Range.new(source_start, source_start + range_length, true).to_a
    destination_values = Range.new(destination_start, destination_start + range_length, true).to_a

    value_map = source_values.zip(destination_values).to_h

    value_map.each_key do |key|
      source_seeds[key]&.each do |seed|
        seed.send("#{destination_name}=", value_map[key])
      end
    end

    seeds.each do |seed|
      seed.send("#{destination_name}=", seed.send(source_name)) unless seed.send(destination_name)
    end
  end
end

puts "Seeds: \n#{seeds.map(&:to_s).join("\n")}"
puts "Answer: #{seeds.map(&:location).min}"
