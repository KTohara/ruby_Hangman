# Ruby Hangman
A CLI Hangman game from [The Odin Project](https://www.theodinproject.com/lessons/ruby-hangman)

Run on [replit](https://replit.com/@KenTohara/rubyHangman)!

## Instructions

This command line version of Hangman chooses a random secret word from first20hours' [10,000 most common word list](https://github.com/first20hours/google-10000-english).

* To win: uncover all letters within the word in 10 tries or less.
* The secret word can be 5 to 12 letters long.
* Guess a letter each turn. Your attempt may not be a letter that has already been guessed.
* The user may start a new game, or load an exisiting save game.
* Saving your progress is possible during any turn.

## Thoughts

This was my first project at implementing a save state feature with file I/O and serialization.

The assignment taught me how to navigate through files and directories and how to manipulate the data through multiple types of serialization formats. I wanted to implement a few things that would mimic any standard saving feature. It came with a lot of head-scratching, but the result was enjoyable when I was finished with the project.

The project isn't as DRY as I'd like it to be, but I would like to keep improving on how to minimize input loops, and learning what Ruby's standards are, even beyond what Rubocop suggests.

Maybe it'll be my next refactoring!