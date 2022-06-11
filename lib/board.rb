# frozen_string_literal: true

require_relative 'color'
require_relative 'messages'

# Word matching logic for Hangman
class Board
  include Messages

  attr_reader :word, :remaining_guesses, :guess, :hidden_word, :guessed, :correct_guess

  def initialize
    @word = generate_word
    @remaining_guesses = 10
    @guess = nil
    @hidden_word = Array.new(@word.length, '_')
    @guessed = []
    @correct_guess = nil
  end

  # loops until guess input matches single alphabet, or 'save' or 'exit'
  def make_guess
    conditionals = [
      proc { |letter| !guessed.map(&:uncolorize).include?(letter) },
      proc { |letter| letter.match?(/^[a-z]$|^exit$|^save$/i) }
    ]
    debugger
    @guess = input_loop(prompt('guess'), warning('guess'), conditionals)
  end

  def check_guess
    return if guess == 'save'

    indices = select_matching_index
    indices.empty? ? guess_incorrectly : guess_correctly(indices)
  end

  def game_over?
    remaining_guesses.zero? || game_win?
  end

  def game_win?
    hidden_word == word
  end

  private

  # choose a random word from word_list.txt, with a length between 5 to 12
  def generate_word
    word_list = File.open('./word_list.txt', 'r')
    File.read(word_list)
        .split(' ')
        .select { |word| word.length.between?(5, 12) }
        .sample
        .split('')
  end

  # finds matching letters, and returns indices from @word
  def select_matching_index
    word.each_with_object([]).with_index do |(char, acc), i|
      acc << i if guess == char
    end
  end

  def guess_incorrectly
    @remaining_guesses -= 1
    guessed << guess.red
    @correct_guess = false
  end

  def guess_correctly(indices)
    indices.each { |i| hidden_word[i] = guess }
    guessed << guess.green
    @correct_guess = true
  end
end
