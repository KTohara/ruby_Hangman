require 'byebug'

class Hangman
  attr_reader :word

  def initialize
    @word = secret_word
  end

  # choose a random word from sample.txt, with a length between 5 to 12
  def secret_word
    File.read('word_list.txt')
        .split(' ')
        .select { |word| word.length.between?(5, 12) }
        .sample
  end
end