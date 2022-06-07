# frozen_string_literal: true

# Text content for Hangman
module Messages
  def display(message)
    {
      'hidden_word' => @hidden_word.join.blue,
      'guessed' => @guessed.join(', ')
    }[message]
  end

  def text(message)
    {
      'guess_remain' => "Incorrect guesses remaining: #{@remaining_guesses}\n\n",
      'final_guess' => "Last chance!\n\n".red,
      'word_size' => "The secret word is #{@word.length} letters long\n".blue
    }[message]
  end

  def prompt(message)
    {
      'guess' => 'Guess a letter in the secret word.',
      'save' => "Type 'save' or 'exit' to leave the current game."
    }[message]
  end

  def warning(message)
    {
      'guess' => 'Guess must be a single letter.'.red,
      'repeat_letter' => 'The letter has already been guessed.'.red
    }[message]
  end
end
