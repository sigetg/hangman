#Author: George Sigety

require 'json'

class Game

  attr_accessor :random_word_array, :guess_array, :guesses_remaining

  def initialize(random_word_array, guess_array=Array.new(random_word_array.length, '_'), guesses_remaining=10)
    @random_word_array = random_word_array
    @guess_array = guess_array
    @guesses_remaining = guesses_remaining
  end

  def to_json
    JSON.dump ({
      :random_word_array => @random_word_array,
      :guess_array => @guess_array,
      :guesses_remaining => @guesses_remaining
    })
  end

  def self.from_json(string)
    data = JSON.load(string)
    self.new(
      data['random_word_array'],
      data['guess_array'],
      data['guesses_remaining']
      )
    end

end

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

def make_guess(game)
  is_winner = false
  guess_letter = gets.chomp.downcase
  if guess_letter == "save"
    save_game(game)
    exit
  end
  if game.guess_array.include?(guess_letter)
    puts "You already guessed that letter! Guess again."
    make_guess(game)
    return
  end
  game.random_word_array.each_with_index do |letter, index|
    if letter == guess_letter
      is_winner = true
      game.guess_array[index] = guess_letter
    end
  end
  puts is_winner ? "You guessed correctly!" : "That letter is not in the word!"
end

def save_game(game)
  Dir.mkdir("saved_games") unless Dir.exist?("saved_games")
  puts "What name would you like to save this game as?"
  input = gets.chomp
  filename = "saved_games/#{input}.json"
  file_json = game.to_json
  File.open(filename, "w") do |file|
    file.write(file_json)
  end
end

def load_game(filename)
  begin
    file_json = File.read(filename)
    game = Game.from_json(file_json)
    puts "Game #{filename.gsub("saved_games/", "")} loaded!"
    puts ""
    game
  rescue => e
    puts "There was an error loading the game: #{e.message}"
  end
end

puts "Hangman! Would you like to:\n1) Load a game\n2) Start a new game"
input = gets.chomp
unless input == "1" || input == "2"
  puts "Invalid input. Please enter either 1 or 2."
  input = gets.chomp
end

if input == "1"
  puts "What game would you like to load? Saved games include:"
  puts files = Dir.entries("saved_games").reject { |entry| entry == '.' || entry == '..' }
  input = gets.chomp
  until files.include?(input)
    puts "Invalid input. Please enter a saved game."
    input = gets.chomp
  end
  filename = "saved_games/#{input}"
  game = load_game(filename)
elsif input == "2"
  game = Game.new(select_random_word().split(''))
  puts "New game started! Please guess a letter or type 'save' to save game."
end

while game.guesses_remaining > 0
  if game.guess_array == game.random_word_array
    puts "You won! The word was #{game.random_word_array.join}."
    break
  else
    make_guess(game)
    game.guesses_remaining -= 1
    puts "Guesses remaining: #{game.guesses_remaining}"
    puts game.guess_array.join(' ')
  end
  if game.guesses_remaining == 0
    puts "You ran out of guesses! The word was '#{game.random_word_array.join}'."
  end
end