# frozen_string_literal: true

require_relative 'board'
require_relative 'messages'
require_relative 'color'
require_relative 'save'

class Game
  include Messages
  include Save

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    system('clear')
    # display_intro
    # prompt_game # New game or load old game

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

  def save_or_exit(input)
    exit if input == 'exit'
    save_game(self) if input == 'save'
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

if $PROGRAM_NAME == __FILE__
  Game.new.play
end
