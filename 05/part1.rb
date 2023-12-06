#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Seed
  attr_accessor :seed, :soil, :fertilizer, :water, :light, :temperature, :humidity, :location

  def initialize(seed)
    self.seed = seed.to_i
  end

  def to_s
    "Seed #{seed}, soil #{soil}, fertilizer #{fertilizer}, water #{water}, light #{light}, temperature #{temperature}, humidity #{humidity}, location #{location}"
  end

  def self.parse_seeds(seed_line)
    seed_line.gsub(/seeds: /, '').split(' ').map { |seed| Seed.new(seed) }
  end
end

class Map
  attr_accessor :source, :destination, :range_mappings

  def initialize(source, destination)
    self.source = source
    self.destination = destination
    self.range_mappings = []
  end

  def add_range_mapping(range_line)
    destination_start, source_start, range_length = range_line.split(' ').map(&:to_i)
    range_mappings << RangeMapping.new(
      source_start:,
      destination_start:,
      range_length:
    )
  end

  def process_seed(seed)
    mapping = range_mappings.find { |range_mapping| range_mapping.has_source?(seed.send(source)) }

    if mapping
      seed.send("#{destination}=", mapping.destination(seed.send(source)))
    else
      seed.send("#{destination}=", seed.send(source))
    end
  end

  def self.parse(map_header)
    match = map_header.match(/(?<source>[a-z]+)-to-(?<destination>[a-z]+) map:/)
    new(match[:source], match[:destination])
  end

  class RangeMapping
    attr_reader :source_start, :destination_start, :range_length

    def initialize(source_start:, destination_start:, range_length:)
      @source_start = source_start
      @destination_start = destination_start
      @range_length = range_length
    end

    def has_source?(source)
      source_start <= source && source < source_start + range_length
    end

    def destination(source)
      destination_start + (source - source_start)
    end
  end
end

seeds = Seed.parse_seeds(input.shift)

until input.empty?
  input.shift
  map = Map.parse(input.shift)
  map.add_range_mapping(input.shift) until input.first.to_s.strip.empty?
  seeds.each { |seed| map.process_seed(seed) }
end

puts "Seeds: \n#{seeds.map(&:to_s).join("\n")}"
puts "Answer: #{seeds.map(&:location).min}"
