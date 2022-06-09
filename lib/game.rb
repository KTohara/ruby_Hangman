# frozen_string_literal: true

require_relative 'board'
require_relative 'messages'
require_relative 'color'
require_relative 'save'

# Hangman initialization methods
class Game
  include Messages
  include Save

  attr_reader :board

  def initialize
    @board = nil
  end

  def play
    new_game
    until board.game_over?
      display_board
      begin
        input = board.make_guess
        save_or_exit(input)
        board.check_guess(input)
      rescue StandardError => e
        display_board(e)
        retry
      end
    end
    game_result
  end

  # prompt for new game or load game
  def new_game
    display_intro
    input = gets.chomp
    until %w[1 2].include?(input)
      display_intro
      input = gets.chomp
    end
    @board = input == '1' ? Board.new : load_game
  end

  def save_or_exit(input)
    exit if input == 'exit'
    save_game(board) if input == 'save'
  end

  def game_result
    display_board
    puts board.game_win? ? text('win') : text('lose')
    repeat_game
  end

  def repeat_game
    puts prompt('replay')
    begin
      input = gets.chomp
      raise prompt('replay') unless %w[1 2].include?(input)

      if input == '1'
        Game.new.play
      else
        puts text('thanks')
        exit
      end
    rescue StandardError => e
      system('clear')
      puts e
      retry
    end
  end
end

Game.new.play if $PROGRAM_NAME == __FILE__
