#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.readlines('./input.txt').map(&:chomp)

class Hand
  include Comparable
  attr_reader :cards, :bid
  attr_accessor :rank

  RANKED_HAND_TYPES = [
    :high_card,
    :one_pair,
    :two_pairs,
    :three_of_a_kind,
    :full_house,
    :four_of_a_kind,
    :five_of_a_kind,
  ]

  RANKED_CARD_TYPES = %w[2 3 4 5 6 7 8 9 T J Q K A]

  def initialize(input_line)
    cards, bid = input_line.split(' ')
    @bid = bid.to_i
    @cards = cards
  end

  def winnings
    bid * rank
  end

  def hand_type
    return @hand_type if @hand_type

    unique_cards = cards.chars.uniq

    @hand_type =
      case unique_cards.size
      when 1
        :five_of_a_kind
      when 2
        card_counts = unique_cards.map { |card| cards.count(card) }
        card_counts.include?(4) ? :four_of_a_kind : :full_house
      when 3
        card_counts = unique_cards.map { |card| cards.count(card) }
        card_counts.include?(3) ? :three_of_a_kind : :two_pairs
      when 4
        :one_pair
      else
        :high_card
      end
  end

  def to_s
    "#{cards} (#{hand_type}) bid: #{bid}, rank: #{rank}"
  end

  def <=>(other)
    result = RANKED_HAND_TYPES.index(hand_type) <=> RANKED_HAND_TYPES.index(other.hand_type)
    return result unless result.zero?

    cards.chars.zip(other.cards.chars).each do |char, other_char|
      result = RANKED_CARD_TYPES.index(char) <=> RANKED_CARD_TYPES.index(other_char)
      return result unless result.zero?
    end

    0
  end
end

hands = input.map { |line| Hand.new(line) }.sort
hands.each_index { |index| hands[index].rank = index + 1 }
puts "Answer: #{hands.map(&:winnings).sum}"
