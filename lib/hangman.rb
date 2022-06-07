# frozen_string_literal: true

require 'byebug'
require_relative 'color'
require_relative 'messages'

# Game logic
class Hangman
  include Messages

  def initialize
    @word = generate_word
    @remaining_guesses = 10
    @hidden_word = Array.new(@word.length, '_')
    @guessed = []
    play
  end

  def play
    # display_intro
    # prompt_game # New game or load old game
    puts text('word_size')
    until remaining_guesses.zero?
      make_guess
      # check_guess
      #   #save_game if 'save', exit if 'exit'
      #   compare to @hidden_word - red if incorrect, green if correct
      #   @remaining_guesses -= 1 unless word.include?(input)
      # update_hidden_word
      #   find indices of letter in word, update @hidden_word based on indices
      # game over?
      #   !@hidden_word.include?('_')
      #   @remaining_guesses.zero?
      @remaining_guesses -= 1
    end
    # repeat_game
  end

  private

  attr_reader :word, :hidden_word, :remaining_guesses, :guessed

  # choose a random word from sample.txt, with a length between 5 to 12
  def generate_word
    File.read('word_list.txt')
        .split(' ')
        .select { |word| word.length.between?(5, 12) }
        .sample
  end

  # ask for input, and begin guess loop
  def make_guess
    system('clear')
    display_board
    puts prompt('guess')
    puts prompt('save')
    input = gets.chomp.downcase
    guess_loop(input)
  end

  def display_board
    case remaining_guesses
    when 1 then print text('final_guess')
    when (2..3) then print text('guess_remain').red
    when (4..5) then print text('guess_remain').yellow
    else print text('guess_remain')
    end
    puts display('hidden_word')
    puts display('guessed')
  end

  # loops until guess input matches single alphabet, or 'save' or 'exit'
  def guess_loop(input)
    until input.match?(/^[a-z]{1}$/) || %w[save exit].include?(input)
      puts guessed.include?(input) ? warning('repeat_letter') : warning('guess')
      puts prompt('save')
      input = gets.chomp.downcase
    end
  end
end
