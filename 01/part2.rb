#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

DIGIT_REGEX = /(one|two|three|four|five|six|seven|eight|nine|zero|[0-9])/

calibration_values = input.map do |line|
  puts "Line: #{line}"

  # Take advantage of the fact that * is a greedy operator
  first_digit = line.match(/(one|two|three|four|five|six|seven|eight|nine|zero|[0-9])(.*)/)[1]
  last_digit = line.match(/(.*)(one|two|three|four|five|six|seven|eight|nine|zero|[0-9])/)[2]

  digits = [first_digit, last_digit].map do |digit|
    puts "Digit: #{digit}"

    case digit
    when 'one' then '1'
    when 'two' then '2'
    when 'three' then '3'
    when 'four' then '4'
    when 'five' then '5'
    when 'six' then '6'
    when 'seven' then '7'
    when 'eight' then '8'
    when 'nine' then '9'
    when 'zero' then '0'
    else digit
    end
  end

  puts "Digits: #{digits.inspect}"
  puts "\n"
  "#{digits[0]}#{digits[-1]}".to_i
end

puts "Calibration values: #{calibration_values.inspect}"
puts "Answer: #{calibration_values.sum}"
