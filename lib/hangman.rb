
def select_random_word()
  file = File.open('english_words.txt', 'r')
  words = []
  file.each_line do |word|
    if word.length > 4 && word.length < 13
      words.push(word.strip)
    end
  end

  random_word = words.sample
end

def make_guess(guess_array, random_word_array)
  guess_letter = gets.chomp.downcase
  is_winner = false
  if guess_array.include?(guess_letter)
    puts "You already guessed that letter! Guess again."
    make_guess(guess_array, random_word_array)
  end
  random_word_array.each_with_index do |letter, index|
    if letter == guess_letter
      is_winner = true
      guess_array[index] = guess_letter
    end
  end
  puts is_winner ? "You guessed correctly!" : "That letter is not in the word!"
end


random_word_array = select_random_word().split('')
puts random_word_array.join
guess_array = Array.new(random_word_array.length, '_')
guesses_remaining = 10

puts "Hangman! You have #{guesses_remaining} guesses to guess the word!"
puts guess_array.join(' ')

while guesses_remaining > 0
  if guess_array == random_word_array
    puts "You won! The word was #{random_word_array.join}."
    break
  else
    make_guess(guess_array, random_word_array)
    guesses_remaining -= 1
    puts "Guesses remaining: #{guesses_remaining}"
    puts guess_array.join(' ')
  end
  if guesses_remaining == 0
    puts "You ran out of guesses! The word was #{random_word_array}."
  end
end