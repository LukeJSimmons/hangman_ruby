require_relative('./word_generator')
require('rainbow/refinement')
using Rainbow
require('yaml')

class Hangman
  attr_reader :answer

  def initialize
    @answer = WordGenerator.new.generate_word()
    @hidden_answer = []
    @incorrect_letters = []
    @max_incorrect_guesses = 0
  end

  def play
    puts "Would you like to load a saved game or start a new?"
    answer = gets.chomp
    if answer == 'load'
      self.load_game
    elsif answer == 'new'
      puts "Input max wrong letters"
      @max_incorrect_guesses = gets.chomp.to_i
    else
      puts "Please enter either 'load' or 'new'"
      answer = gets.chomp
    end
  
    self.display_incorrect_letters()
    self.hide_answer()
    self.display_hidden_answer()
    loop do
      guess()

      if @hidden_answer.join() == @answer
        puts "You Win!".green
        break
      elsif @incorrect_letters.length >= @max_incorrect_guesses
        puts "You Lost!".red
        puts "The answer was #{@answer}".blue
        break
      end
    end
    
  end

  def guess
    puts "\nInput Guess Letter".green
    guess_letter = gets.chomp

    if guess_letter == 'exit'
      exit
    elsif guess_letter == 'save'
      self.save_game
      exit
    elsif guess_letter == 'load'
      self.load_game
      self.display_incorrect_letters()
      self.hide_answer()
      self.display_hidden_answer()
      return
    end

    self.reveal_letter(guess_letter)
  end

  def hide_answer
    if @hidden_answer.length > 0
      return @hidden_answer
    end
    @hidden_answer = Array.new(@answer.split('').length, "_")
  end

  def display_hidden_answer
    puts "\n" + @hidden_answer.join(' ')
  end

  def display_incorrect_letters
    puts "\n#{@max_incorrect_guesses - @incorrect_letters.length} Wrong Guesses Left".blue
    puts "Incorrect Letters: #{@incorrect_letters.join(' ')}"
  end

  def reveal_letter(letter)
    answer_arr = @answer.split('')
    revealed = false
    answer_arr.each_with_index do |answer_letter, index|
      if answer_letter == letter.downcase
        @hidden_answer[index] = letter.downcase
        revealed = true
      end
    end

    if revealed == false
      if @incorrect_letters.include?(letter) == false
        puts "\nThat Letter is not in the Answer!".red
        @incorrect_letters << letter
      else
        puts "\nYou Already Guesses That Letter!"
      end
    end

    self.display_incorrect_letters()
    self.display_hidden_answer()
  end

  def save_game
    save_data = YAML.dump({
      answer: @answer,
      hidden_answer: @hidden_answer,
      incorrect_letters: @incorrect_letters,
      max_incorrect_guesses: @max_incorrect_guesses
    })
    File.open("save_data.yml", "w") { |file| file.write(save_data)}
  end

  def load_game
    loaded_data = YAML.load(File.read("save_data.yml"))
    @answer = loaded_data[:answer]
    @hidden_answer = loaded_data[:hidden_answer]
    @incorrect_letters = loaded_data[:incorrect_letters]
    @max_incorrect_guesses = loaded_data[:max_incorrect_guesses]
  end

end

game = Hangman.new
game.play