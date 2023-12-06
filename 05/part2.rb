#!/usr/bin/env ruby
# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"

input = File.readlines('./input.txt').map(&:chomp)

class SeedRange
  attr_accessor :seed, :soil, :fertilizer, :water, :light, :temperature, :humidity, :location

  def initialize(start, length)
    self.seed = [(start.to_i..(start.to_i + length.to_i - 1))]
    self.soil = []
    self.fertilizer = []
    self.water = []
    self.light = []
    self.temperature = []
    self.humidity = []
    self.location = []
  end

  def min_location
    location.map { |l| l.first }.min
  end

  def to_s
    "Seed #{seed}, soil #{soil}, fertilizer #{fertilizer}, water #{water}, light #{light}, temperature #{temperature}, humidity #{humidity}, location #{location}"
  end

  def add_attribute(name, value)
    send(name) << value
    send(name).sort_by! { |range| range.first }
    send(name)
  end

  def self.parse_seeds(seed_line)
    seeds = []
    seed_line.gsub(/seeds: /, '').split(' ').each_slice(2) do |start, range_length|
      seeds << new(start, range_length)
    end
    seeds
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
    sources = seed.send(source)

    mapped_sources = []

    sources.each do |source|
      mappings = range_mappings.select { |mapping| mapping.includes_source?(source) }

      if mappings.any?
        mappings.each do |mapping|
          seed.add_attribute(destination, mapping.destination(source))
          mapped_sources << mapping.source_intersection(source)
        end
      else
        seed.add_attribute(destination, source)
        mapped_sources << source
      end
    end

    min_source = sources.map(&:first).min
    min_mapped_source = mapped_sources.map(&:first).min

    if min_source < min_mapped_source
      seed.add_attribute(destination, Range.new(min_source, min_mapped_source - 1))
    end

    max_source = sources.map(&:last).max
    max_mapped_source = mapped_sources.map(&:last).max

    if max_source > max_mapped_source
      seed.add_attribute(destination, Range.new(max_mapped_source + 1, max_source))
    end
  end

  def to_s
    "Map from #{source} to #{destination} with #{range_mappings}"
  end

  def self.parse(map_header)
    match = map_header.match(/(?<source>[a-z]+)-to-(?<destination>[a-z]+) map:/)
    new(match[:source], match[:destination])
  end

  class RangeMapping
    attr_reader :source_range, :destination_range

    def initialize(source_start:, destination_start:, range_length:)
      @source_range = Range.new(source_start, source_start + range_length - 1)
      @destination_range = Range.new(destination_start, destination_start + range_length - 1)
    end

    def includes_source?(source)
      source_range.overlaps?(source)
    end

    def destination(source)
      intersection = source_intersection(source)
      start = destination_range.first + intersection.first - source_range.first
      finish = [start + (intersection.last - intersection.first), destination_range.last].min
      Range.new(start, finish)
    end

    def unmapped_destinations(source)
      unmapped_destinations = []
      return unmapped_destinations if source_range.cover?(source)

      unmapped_destinations << Range.new(source.first, source_range.first - 1) if source.first < source_range.first
      unmapped_destinations << Range.new(source_range.last + 1, source.last) if source.last > source_range.last

      unmapped_destinations
    end

    def source_intersection(source)
      Range.new([source.first, source_range.first].max, [source.last, source_range.last].min)
    end
  end
end

seeds = SeedRange.parse_seeds(input.shift)

until input.empty?
  input.shift
  map = Map.parse(input.shift)
  map.add_range_mapping(input.shift) until input.first.to_s.strip.empty?
  seeds.each { |seed| map.process_seed(seed) }
end

puts "Seeds: \n#{seeds.map(&:to_s).join("\n")}"
puts "Answer: #{seeds.map(&:min_location).min}"
