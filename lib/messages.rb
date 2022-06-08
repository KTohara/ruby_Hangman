# frozen_string_literal: true

# Text content for Hangman
module Messages
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
      'hidden_word' => "#{@hidden_word.join.upcase.blue}\n\n",
      'guessed' => "Guessed Letters: #{@guessed.join(' ')}\n\n"
    }[message]
  end

  def text(message)
    {
      'guess_remain' => "Incorrect guesses remaining: #{@remaining_guesses}\n\n",
      'final_guess' => "Last chance!\n\n".red,
      'correct' => "Good guess!\n".green,
      'incorrect' => "Oof, bad guess.\n".red,
      'win' => "You've guessed the word! You win! ᕦ(ò_óˇ)ᕤ\n".green,
      'lose' => "'#{@word.join.upcase}' was the word. You lose. (⌣̩̩́_⌣̩̩̀)\n".red,
      'thanks' => "\n\nThanks for playing!!"
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
