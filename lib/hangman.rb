require 'yaml'
class Hangman

  attr_reader :valid_words, :secret_word
  attr_accessor :visible_word, :chances, :letters
  def initialize
    valid_words = []
    File.readlines('5desk.txt').each do |line|
      if line.chomp.length > 4 && line.chomp.length < 13
	    valid_words.push(line.chomp)
	  end
    end
    @valid_words = valid_words
    @secret_word = valid_words.sample.downcase
    @visible_word = "_ " * @secret_word.length
    @chances = 10
    @letters = %w(a b c d e f g h i j k l m n o p q r s t v u w x y z)
  end

  def guess
    puts "Please enter a letter to guess from the following: #{@letters}. Type ! to save and exit. Type @ to load a previous save."
  	choice = gets.chomp.downcase
    if @letters.include? choice
  	  @letters.delete(choice)
  	  answer = @secret_word.scan(/./)
  	  correct_guess = false
  	  answer.each_with_index do |alphabet, index|
  	    if choice == alphabet 
  	  	  visible_word[index * 2] = choice
  	  	  correct_guess = true
  	    end
  	  end
  	  if correct_guess
  	    puts "You guessed a letter correctly. Congratulations."
  	    @chances = 0 unless visible_word.include? "_"
  	  else
  	    puts "Sorry. You did not enter a correct letter."
  	    @chances -= 1
  	  end
  	elsif choice == "!"
  		save_game
  		puts "The game has been saved."
  		exit
  	elsif choice == "@"
  		puts "Loading."
        load_game
  	else
  	  puts "Sorry, that is not a valid choice. Try again."
  	  guess
    end
  end

  def save_game
  	File.open("saves/save.yaml", "w") {|file| file.write(YAML::dump(self))}
  end

  def load_game
    load_file = File.open("saves/save.yaml")
    yaml = load_file.read
    load = YAML::load(yaml)
    load.play 
  end

  def round
  	puts "You currently have #{@chances} chances to guess incorrectly."
  	puts "The word display is currently: #{@visible_word}"
    guess
  end

  def play
    puts "Welcome to Hangman!"
    round while @chances > 0
    puts "The answer was #{@secret_word}!"
  end

end

game = Hangman.new
game.play



