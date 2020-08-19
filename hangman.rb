class Hangman
  require "yaml"
  require_relative 'word.rb'
  attr_accessor :hanged, :errors, :hangman, :displayed_characters, :typed_letters

  def initialize(hanged = false, errors = 0, hangman = "", displayed_characters = [], typed_letters = [])
    @hanged = hanged
    @errors = errors
    @hangman = hangman
    @displayed_characters = displayed_characters
    @typed_letters = typed_letters
  end

  def begin_game
    create_secret_word
    # puts "#{@word}" # For the purpose of testing
    puts "\nWelcome to Hangman!"
    draw_hangman
    display_characters
    while @hanged == false
      ask_for_letter
      check_matches
      display_characters
    end
  end

  private
  
  def create_secret_word
    @word = Word.new.sample.chomp.upcase
    number_of_characters = @word.chomp.length
    number_of_characters.times do
      @displayed_characters << "_"
    end
  end

  def display_characters
    if @hanged == false
      puts @displayed_characters.join(" ")
      puts "\nGuesses: #{@typed_letters.join(" ")}" unless @typed_letters.empty?
    end
  end

  def draw_hangman
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

  def check_matches
    @word.each_char.with_index do |letter, idx|
      if letter == @typed_letter
        @displayed_characters[idx] = @typed_letter
        draw_hangman
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
    @typed_letters << @typed_letter
  end

  def ask_for_a_rematch
    puts "\nThe word was #{@word}.\nYou were hanged!\nTry again? Type yes or no."
    answer = gets.chomp.downcase
    if answer == "yes"
      @hanged = false
      @errors = 0
      @displayed_characters = []
      @typed_letters = []
      begin_game
    elsif answer == "no"
      puts "Good bye!"
    else
      puts "You typed an invalid answer!"
      ask_for_a_rematch
    end
  end

  def ask_for_letter
    puts "\nType a letter to figure out the secret word:"
    @typed_letter = gets.chomp.upcase
    @typed_letters.each do |c|
      if c == @typed_letter
        puts "\nYou already tried this letter before, try another one!"
        draw_hangman
        display_characters
        ask_for_letter
      end
    end
    if @typed_letter.length > 1
      puts "\nYou can type only one letter at a time!"
      draw_hangman
      display_characters
      ask_for_letter
    end
  end
end

test = Hangman.new
test.begin_game
# serialized_object = YAML::dump(test)
# puts serialized_object