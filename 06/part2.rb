#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

times = [input.shift.gsub(/Time:/, '').gsub(/\s+/, '').to_i]
distances = [input.shift.gsub(/Distance:/, '').gsub(/\s+/, '').to_i]

records = times.zip(distances).to_h
puts "Records: #{records}"

def distance_traveled(total_time:, hold_time:)
  speed = hold_time
  travel_time = total_time - hold_time
  travel_time * speed
end

# The peak distance happens somewhere at the half way point
win_count = records.map do |total_time, record_distance|
  puts "Time: #{total_time}, Record distance: #{record_distance}"
  peak_time = hold_time = total_time / 2
  distance = distance_traveled(total_time:, hold_time:)
  puts "Peak time: #{peak_time}, distance: #{distance}"

  # Estimate the lowest hold time that will beat the record using
  # a binary seaerch
  until distance <= record_distance
    hold_time /= 2
    distance = distance_traveled(total_time:, hold_time:)
    puts "Hold time: #{hold_time}, distance: #{distance}"
  end

  # Find the actual lowest time
  hold_time += 1 until distance_traveled(total_time:, hold_time:) > record_distance

  min_time = hold_time
  puts "Min time: #{min_time}"

  max_time = total_time - min_time
  puts "Max time: #{max_time}"

  max_time - min_time + 1
end

puts "Margin of error: #{win_count.inject(:*)}"
