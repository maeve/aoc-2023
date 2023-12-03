#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

calibration_values = input.map do |line|
  digits = line.gsub(/[^0-9]/, '').chars
  "#{digits[0]}#{digits[-1]}".to_i
end

puts "Answer: #{calibration_values.sum}"
