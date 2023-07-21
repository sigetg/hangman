
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

puts select_random_word()