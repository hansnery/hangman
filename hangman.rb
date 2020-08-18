class Hangman
  require_relative 'word.rb'
  
  def self.create_secret_word
    @word = Word.new.sample.chomp.upcase
    @displayed_characters = []
    number_of_characters = @word.chomp.length
    number_of_characters.times do
      @displayed_characters << "_"
    end
  end

  def self.display_characters
    puts @displayed_characters.join(" ")
  end

  def self.check_matches
    @word.each_char.with_index do |letter, idx|
      if letter == @typed_letter
        @displayed_characters[idx] = @typed_letter
      end
    end
  end

  def self.ask_for_letter
    puts "\nType a letter to figure out the secret word: "
    @typed_letter = gets.chomp.upcase
  end

  create_secret_word

  puts "Welcome to Hangman! #{@word}"

  display_characters

  ask_for_letter

  check_matches

  display_characters
  #if there are matches, reveal them
  
  #if there are no matches draw another stick
end
