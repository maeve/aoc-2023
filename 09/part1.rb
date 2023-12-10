#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class OasisSequence
  attr_accessor :steps

  def initialize(input)
    self.steps = [input.split(' ').map(&:to_i)]
  end

  def next_number
    return @next_number if @next_number

    predict_steps

    steps.reverse.each_cons(2) do |current_step, previous_step|
      previous_step << previous_step.last + current_step.last
    end

    @next_number = steps.first.last
  end

  def to_s
    steps.map { |step| step.join(' ') }.join("\n")
  end

  private

  def predict_steps
    while steps.last.any? { |s| !s.zero? }
      differences = []
      steps.last.each_cons(2) { |a, b| differences << (b - a) }
      steps << differences
    end
  end
end

answer = input.map { |line| OasisSequence.new(line).next_number }.sum
puts "Answer: #{answer}"
