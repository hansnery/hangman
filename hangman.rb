class Hangman
  require 'yaml'
  require_relative 'word.rb'
  attr_accessor :hanged, :errors, :hangman, :displayed_characters, :typed_letters

  def initialize(hanged = false, errors = 0, hangman = "", displayed_characters = [], typed_letters = [])
    @hanged = hanged
    @errors = errors
    @hangman = hangman
    @displayed_characters = displayed_characters
    @typed_letters = typed_letters
  end

  def new_game
    menu
  end

  protected

  def play_game
    if @hanged == false
      puts "\nYou can type 'save' at any time to save the game or 'menu' to return to the menu."
      draw_hangman
      display_characters
      while @hanged == false
        ask_for_letter
        check_matches
        display_characters
      end
    end
  end

  private

  def menu
    puts "\nWelcome to Hangman!\n\n1. Play\n2. Load\n3. Exit\n\nType one of the numbers above to proceed:"
    choice = gets.chomp
    if choice == "1"
      reset_game
      play_game
    elsif choice == "2"
      @hanged = true
      puts "\nLoading game..."
      saved_game = File.open('savegame.yaml')
      @loaded_game = YAML.load(saved_game)
      @loaded_game.play_game
    elsif choice == "3"
      end_game
    else
      puts "\nType a valid number!"
      menu
    end
  end
  
  def create_secret_word
    @word = Word.new.sample.chomp.upcase
    # puts @word # For testing purposes
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

  def check_matches
    @word.each_char.with_index do |letter, idx|
      if letter == @typed_letter
        @displayed_characters[idx] = @typed_letter
      end
    end
    if @displayed_characters.join("") == @word
      ask_to_play_again
    end
    if @displayed_characters.none? { |n| n == @typed_letter }
      @errors += 1 unless @typed_letter == "SAVE" || @typed_letter == "MENU"
    end
    draw_hangman
    if @errors > 5
      @hanged = true
      ask_for_a_rematch
    end
    @typed_letters << @typed_letter unless @typed_letter == "SAVE" || @typed_letter == "MENU"
  end

  def ask_for_letter
    puts "\nType a letter to figure out the secret word:"
    @typed_letter = gets.chomp.upcase
    if @typed_letter == "SAVE"
      saved_game = YAML.dump(self)
      File.open('savegame.yaml', 'w') { |save| save.write saved_game }
    elsif @typed_letter == "MENU"
      menu
    else
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

  def ask_for_a_rematch
    puts "\nThe word was #{@word}.\nYou were hanged!\nTry again? Type 'yes' or 'no'."
    answer = gets.chomp.downcase
    if answer == "yes"
      reset_game
    elsif answer == "no"
      end_game
    else
      puts "You typed an invalid answer!"
      ask_for_a_rematch
    end
  end

  def ask_to_play_again
    puts "\nYou win! The correct word was #{@word}! Do you want to play again? Type 'yes' or 'no'."
    answer = gets.chomp.downcase
    if answer == "yes"
      reset_game
    elsif answer == "no"
      end_game
    else
      puts "You typed an invalid answer!"
      ask_to_play_again
    end
  end

  def reset_game
    @hanged = false
    @errors = 0
    @displayed_characters = []
    create_secret_word
    @typed_letters = []
    play_game
  end

  def end_game
    puts "\nGood bye!"
    @hanged = true
    return
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
    if @hanged == false
      puts "#{@hangman}"
    end
  end
end

test = Hangman.new
test.new_game