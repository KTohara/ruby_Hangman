# frozen_string_literal: true

require_relative 'board'
require_relative 'messages'
require_relative 'color'
require_relative 'save'
require 'yaml'

# Hangman initialization methods
class Game
  include Messages
  include Save

  def initialize
    @board = nil
  end

  def play
    new_game
    play_turn until board.game_over?
    game_result
    repeat_game
  end

  private

  attr_reader :board

  # prompt for [1] new game or [2] load game
  def new_game
    conditional = [proc { |choice| %w[1 2].include?(choice) }]
    input = input_loop(method(:display_intro), method(:display_intro), conditional)
    @board = input == '1' ? Board.new : load_game
  end

  def play_turn
    display_board
    board.make_guess
    save_or_exit
    board.check_guess
  end

  def save_or_exit
    exit if board.guess == 'exit'
    save_game(board) if board.guess == 'save'
  end

  def game_result
    display_board
    puts board.game_win? ? text('win') : text('lose')
  end

  # prompt for [1] replay or [2] exit, else clear and repeat prompt
  def repeat_game
    conditional = [proc { |choice| %w[1 2].include?(choice) }]
    input = input_loop(prompt('replay?'), warning('invalid'), conditional)
    input == '1' ? Game.new.play : exit_game
  end

  def exit_game
    puts text('thanks')
    exit
  end
end

Game.new.play if $PROGRAM_NAME == __FILE__
