class Word
  def sample
    File.open("5desk.txt",'r') do |word|
      words = word.readlines

      filtered_words = []

      words.map { |word|
        if word.chomp.length > 3 && word.chomp.length < 13
          filtered_words << word
        end
      }

      chosen_word = filtered_words.sample()

      chosen_word
    end
  end
end
