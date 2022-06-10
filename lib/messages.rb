# frozen_string_literal: true

# Text content and Display for Hangman
module Messages
  def input_loop(message, warning, procs)
    message.instance_of?(Method) ? message.call : (puts message)
    begin
      input = gets.chomp
      true_or_false = procs.all? { |prc| prc.call(input) }
      true_or_false ? (return input) : (raise warning)
    rescue StandardError
      warning.instance_of?(Method) ? warning.call : (puts warning)
      retry
    end
  end

  def display_intro
    system('clear')
    puts 'Lets play...'
    print display_banner
    puts "Play a new game, or Load a saved game?\n\n"
    puts "#{'[1]'.blue} Play new game"
    puts "#{'[2]'.blue} Load saved game\n"
  end

  def display_board
    system('clear')
    print display_banner
    remaining_guess_case
    puts display('hidden_word')
    display_correct_or_incorrect
    puts display('guessed')
  end

  def remaining_guess_case
    case board.remaining_guesses
    when 1 then print text('final_guess')
    when (2..3) then print text('guess_remain').red
    when (4..5) then print text('guess_remain').yellow
    else print text('guess_remain')
    end
  end

  def display_correct_or_incorrect
    return if board.correct_guess.nil?

    puts board.correct_guess ? text('correct') : text('incorrect')
  end

  def prompt_load_message(files)
    puts
    files.each { |file| puts file }
    puts prompt('load_game')
  end

  def display_banner
    "
╭╮╱╭╮ ╭━━━╮ ╭━╮╱╭╮ ╭━━━╮ ╭━╮╭━╮ ╭━━━╮ ╭━╮╱╭╮
┃┃╱┃┃ ┃╭━╮┃ ┃┃╰╮┃┃ ┃╭━╮┃ ┃┃╰╯┃┃ ┃╭━╮┃ ┃┃╰╮┃┃
┃╰━╯┃ ┃┃╱┃┃ ┃╭╮╰╯┃ ┃┃╱╰╯ ┃╭╮╭╮┃ ┃┃╱┃┃ ┃╭╮╰╯┃
┃╭━╮┃ ┃╰━╯┃ ┃┃╰╮┃┃ ┃┃╭━╮ ┃┃┃┃┃┃ ┃╰━╯┃ ┃┃╰╮┃┃
┃┃╱┃┃ ┃╭━╮┃ ┃┃╱┃┃┃ ┃╰┻━┃ ┃┃┃┃┃┃ ┃╭━╮┃ ┃┃╱┃┃┃
╰╯╱╰╯ ╰╯╱╰╯ ╰╯╱╰━╯ ╰━━━╯ ╰╯╰╯╰╯ ╰╯╱╰╯ ╰╯╱╰━╯
    \n".red
  end

  def display(message)
    {
      'hidden_word' => "#{board.hidden_word.join.upcase.blue}\n\n",
      'guessed' => "Guessed Letters: #{board.guessed.join(' ')}\n\n"
    }[message]
  end

  def text(message)
    {
      'guess_remain' => "Incorrect guesses remaining: #{board.remaining_guesses}\n\n",
      'final_guess' => "Last chance!\n\n".red,
      'correct' => "Good guess!\n".green,
      'incorrect' => "Oof, bad guess.\n".red,
      'win' => "You've guessed the word! You win! ᕦ(ò_óˇ)ᕤ\n".green,
      'lose' => "'#{board.word.join.upcase}' was the word. You lose. (⌣̩̩́_⌣̩̩̀)\n".red,
      'thanks' => "\nThanks for playing!!"
    }[message]
  end

  def prompt(message)
    {
      'guess' => "Guess a letter in the secret word.\n" \
                 "Type '#{'SAVE'.blue}' or '#{'EXIT'.blue}' to leave the current game.",
      'replay?' => "Play again?\n\n#{'[1]'.blue} Play another game\n#{'[2]'.blue} Exit\n",
      'save_name' => "\nEnter a name for your save file or:\n" \
                     "#{'[R]'.blue} Random file name\n" \
                     "#{'[Return]'.blue} Return to game\n",
      'overwrite?' => "\nFile already exists. Re-write save file? \n#{'[Y]'.red} Yes\n#{'[N]'.red} No",
      'load_game' => "\nChoose a save file to load.\n"
    }[message]
  end

  def warning(message, file = nil)
    {
      'guess' => 'Guess must be a single letter, and must have not been already guessed'.red,
      'invalid' => 'Invalid input. Try again.'.red,
      'file_saved' => "\nSave state created: '#{file}'\nGoodbye!".red
    }[message]
  end
end
