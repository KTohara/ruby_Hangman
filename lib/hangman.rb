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
    @correct_guess = nil
    play
  end

  def play
    # display_intro
    # prompt_game # New game or load old game
    until remaining_guesses.zero?
      display_turn_prompt
      input = make_guess
      #   #save if 'save', exit if 'exit'
      check_guess(input)
      
      break if game_win?
    end
    game_result
  end

  private

  attr_reader :word, :hidden_word, :remaining_guesses, :guessed, :correct_guess

  # choose a random word from word_list.txt, with a length between 5 to 12
  def generate_word
    File.read('word_list.txt')
        .split(' ')
        .select { |word| word.length.between?(5, 12) }
        .sample
        .split('')
  end

  def display_turn_prompt
    p word # for debugging
    display_board
    puts prompt('guess')
    puts prompt('save')
  end

  def display_board
    system('clear')
    print display_banner
    remaining_guess_case
    puts display('hidden_word')
    display_guess
    puts display('guessed')
  end

  def remaining_guess_case
    case remaining_guesses
    when 1 then print text('final_guess')
    when (2..3) then print text('guess_remain').red
    when (4..5) then print text('guess_remain').yellow
    else print text('guess_remain')
    end
  end

  def display_guess
    return if correct_guess.nil?

    puts correct_guess ? text('correct') : text('incorrect')
  end

  # loops until guess input matches single alphabet, or 'save' or 'exit'
  def make_guess
    input = gets.chomp.downcase
    exit if input == 'exit'
    save if input == 'save'
    raise warning('guess') unless input.match?(/^[a-z]{1}$/)
    raise warning('repeat_letter') if guessed.include?(input.red) || guessed.include?(input.green)

    input
  rescue StandardError => e
    puts e
    retry
  end

  # check for correct guess, map @hidden_word with guess, decrement guess count if incorrect
  # add input with correct color code to @guessed
  def check_guess(input)
    if word.include?(input)
      hidden_word.map!.with_index { |letter, i| word[i] == input ? input : letter }
      guessed << input.green
      @correct_guess = true
    else
      @remaining_guesses -= 1
      guessed << input.red
      @correct_guess = false
    end
  end

  # serialize method
  def save
    exit
  end

  def game_win?
    hidden_word == word
  end

  def game_result
    display_board
    puts game_win? ? text('win') : text('lose')
    puts prompt('replay')
    repeat_game
    puts text('thanks')
    exit
  end

  def repeat_game
    input = gets.chomp
    raise prompt('replay') unless %w[1 2].include?(input)

    Hangman.new if input == '1'
  rescue StandardError => e
    system('clear')
    puts e
    retry
  end
end
