# frozen_string_literal: true

require 'byebug'
require_relative 'color'
require_relative 'messages'
require_relative 'save'
require 'yaml'

# Game logic
class Board
  include Messages

  attr_reader :word, :hidden_word, :remaining_guesses, :guessed, :correct_guess

  def initialize
    @word = generate_word
    @remaining_guesses = 10
    @hidden_word = Array.new(@word.length, '_')
    @guessed = []
    @correct_guess = nil
  end

  def game_over?
    remaining_guesses.zero? || game_win?
  end

  # loops until guess input matches single alphabet, or 'save' or 'exit'
  def make_guess
    input = gets.chomp.downcase
    return input if %w[save exit].include?(input)
    raise warning('guess') unless input.match?(/^[a-z]{1}$/)
    raise warning('repeat_letter') if guessed.include?(input.red) || guessed.include?(input.green)

    input
  end

  # check for correct guess, map @hidden_word with guess, decrement guess count if incorrect
  # add input with correct color code to @guessed
  def check_guess(input)
    matches = matching_guess(input)
    if matches.empty?
      @remaining_guesses -= 1
      guessed << input.red
      @correct_guess = false
    else
      update_guess(matches, input)
      guessed << input.green
      @correct_guess = true
    end
  end

  def game_win?
    hidden_word == word
  end
  
  private
  
  # choose a random word from word_list.txt, with a length between 5 to 12
  def generate_word
    word_list = File.expand_path('../word_list.txt', __dir__)
    File.read(word_list)
        .split(' ')
        .select { |word| word.length.between?(5, 12) }
        .sample
        .split('')
  end

  def matching_guess(input)
    word.each_with_index.each_with_object([]) do |(char, i), acc|
      acc << i if input == char
    end
  end

  def update_guess(indices, input)
    indices.each { |i| hidden_word[i] = input }
  end
end
