#!/usr/bin/env ruby
# frozen_string_literal: true

require 'strscan'

input = File.readlines('./test-input2.txt').map(&:chomp)

DIGIT_REGEX = /(one|two|three|four|five|six|seven|eight|nine|zero|[0-9])/

calibration_values = input.map do |line|
  digits = []
  scanner = StringScanner.new(line)

  while (digit = scanner.scan_until(DIGIT_REGEX))
    digit = digit.match(DIGIT_REGEX)[0]

    digits << case digit
              when 'one' then 1
              when 'two' then 2
              when 'three' then 3
              when 'four' then 4
              when 'five' then 5
              when 'six' then 6
              when 'seven' then 7
              when 'eight' then 8
              when 'nine' then 9
              when 'zero' then 0
              else digit.to_i
              end
  end

  "#{digits[0]}#{digits[-1]}".to_i
end

puts "Answer: #{calibration_values.sum}"
