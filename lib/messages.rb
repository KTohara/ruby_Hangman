# frozen_string_literal: true

# Text content for Hangman
module Messages
  def display_board(error = nil)
    system('clear')
    print display_banner
    remaining_guess_case
    puts display('hidden_word')
    display_guess
    puts display('guessed')
    puts prompt('guess')
    puts prompt('save')
    puts error
  end

  def remaining_guess_case
    case board.remaining_guesses
    when 1 then print text('final_guess')
    when (2..3) then print text('guess_remain').red
    when (4..5) then print text('guess_remain').yellow
    else print text('guess_remain')
    end
  end

  def display_guess
    return if board.correct_guess.nil?

    puts board.correct_guess ? text('correct') : text('incorrect')
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
      'guess' => 'Guess a letter in the secret word.',
      'save' => "Type 'save' or 'exit' to leave the current game.",
      'replay' => "Play again?\n\n[1] Play another game\n[2] Exit\n"
    }[message]
  end

  def warning(message)
    {
      'guess' => 'Guess must be a single letter.'.red,
      'repeat_letter' => 'The letter has already been guessed.'.red
    }[message]
  end
end
