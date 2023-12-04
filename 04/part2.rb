#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./test-input.txt').map(&:chomp)

class Card
  attr_accessor :id, :winning_numbers, :actual_numbers

  def initialize(id: nil, winning_numbers: [], actual_numbers: [])
    self.id = id
    self.winning_numbers = winning_numbers
    self.actual_numbers = actual_numbers
  end

  def match_count
    actual_numbers.intersection(winning_numbers).size
  end

  def duplicate
    Card.new(
      id: id.clone,
      winning_numbers: winning_numbers.clone,
      actual_numbers: actual_numbers.clone
    )
  end

  def to_s
    "Card #{id}, matches: #{match_count}"
  end

  def self.parse(input)
    matches = input.match(/Card +(?<id>\d+): (?<winning>[0-9 ]*) \| (?<actual>[0-9 ]*)/)
    Card.new(
      id: matches[:id].to_i,
      winning_numbers: matches[:winning].split(' ').compact.map(&:to_i),
      actual_numbers: matches[:actual].split(' ').compact.map(&:to_i)
    )
  end
end

class CardList
  attr_accessor :cards

  def initialize(input)
    self.cards = input.map { |line| Card.parse(line) }.group_by(&:id)
  end

  def process
    cards.keys.sort.each do |id|
      cards[id].each do |card|
        next if card.match_count.zero?

        (1..card.match_count).each do |offset|
          copy_id = id + offset
          cards[copy_id] << cards[copy_id].first.duplicate
        end
      end
    end
  end

  def card_count
    cards.values.map(&:size).sum
  end
end

cards = CardList.new(input)
cards.process
puts "Answer: #{cards.card_count}"
