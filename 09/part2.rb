#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class OasisHistory
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

  def previous_number
    return @previous_number if @previous_number

    predict_steps

    steps.last.unshift(0)

    steps.reverse.each_cons(2) do |current_step, previous_step|
      previous_step.unshift(previous_step.first - current_step.first)
    end

    @previous_number = steps.first.first
  end

  def to_s
    steps.map { |step| step.join(' ') }.join("\n")
  end

  private

  def predict_steps
    return if @predict_steps

    while steps.last.any? { |s| !s.zero? }
      differences = []
      steps.last.each_cons(2) { |a, b| differences << (b - a) }
      steps << differences
    end

    @predict_steps = true
  end
end

answer = input.map { |line| OasisHistory.new(line).previous_number }.sum
puts "Answer: #{answer}"
