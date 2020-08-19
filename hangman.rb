class Hangman
  require "yaml"
  require_relative 'word.rb'

  @hanged = false
  @errors = 0
  @hangman = ""
  @displayed_characters = []
  @typed_letters = []
  
  def self.create_secret_word
    @word = Word.new.sample.chomp.upcase
    number_of_characters = @word.chomp.length
    number_of_characters.times do
      @displayed_characters << "_"
    end
  end

  def self.display_characters
    puts @displayed_characters.join(" ")
    puts "\nGuesses: #{@typed_letters.join(" ")}" unless @typed_letters.empty?
  end

  def self.draw_hangman
    case @errors
    when 0
      @hangman = %{
        ------ 
             |
             |
             |
             |
     }
    when 1
      @hangman = %{
        ------ 
        O    |
             |
             |
             |
     }
    when 2
      @hangman = %{
        ------ 
        O    |
       /     |
             |
             |
     }
    when 3
      @hangman = %{
        ------ 
        O    |
       /|    |
             |
             |
     }
    when 4
      @hangman = %{
        ------ 
        O    |
       /|\\   |
             |
             |
     }
    when 5
      @hangman = %{
        ------ 
        O    |
       /|\\   |
       /     |
             |
     }
    when 6
      @hangman = %{
         ------ 
         O    |
        /|\\   |
        / \\   |
              |
      }
    end
    puts "#{@hangman}"
  end

  def self.check_matches
    @word.each_char.with_index do |letter, idx|
      if letter == @typed_letter
        @displayed_characters[idx] = @typed_letter
      end
    end
    if @displayed_characters.none? { |n| n == @typed_letter }
      @errors += 1
      draw_hangman
    end
    if @errors > 5
      @hanged = true
      ask_for_a_rematch
    end
  end

  def self.ask_for_a_rematch
    puts "\nYou were hanged!\nTry again? Type yes or no."
    answer = gets.chomp.downcase
    if answer == "yes"
      @hanged = false
      @errors = 0
      @displayed_characters = []
      @typed_letters = []
      begin_game
    elsif answer == "no"
      return
    else
      puts "You typed an invalid answer!"
      ask_for_a_rematch
    end
  end

  def self.ask_for_letter
    puts "\nType a letter to figure out the secret word: "
    @typed_letter = gets.chomp.upcase
    @typed_letters << @typed_letter
  end

  def self.begin_game
    create_secret_word
    # puts "#{@word}"
    puts "\nWelcome to Hangman!"
    draw_hangman
    display_characters
    while @hanged == false
      ask_for_letter
      check_matches
      display_characters
    end
  end

  begin_game
end

test = Hangman.new

# serialized_object = YAML::dump(test)

# test.begin_game
# puts test