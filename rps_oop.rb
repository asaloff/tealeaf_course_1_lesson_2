class Hand
  include Comparable

  attr_reader :value

  def initialize(v)
    @value = v
  end

  def <=>(another_hand)
    if @value == another_hand.value
      0
    elsif (@value == 'p' && another_hand.value =='r') || (@value == 'r' && another_hand.value =='s') || (@value == 's' && another_hand.value =='p')
      1
    else
      -1
    end
  end

  def display_winning_message
    case @value
    when 'p'
      puts 'Paper covers Rock!!'
    when 'r'
      puts 'Rock smashes Scissors!!'
    when 's'
      puts 'Scissors cuts Paper!!'
    end
  end
end

class Player
  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "#{name} currently has a choice of #{self.hand.value}"
  end
end

class Human < Player
  
  def pick_hand
    begin
    puts "Pick one: (p, r, s)"
    c = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(c)

    self.hand = Hand.new(c)
  end
end

class Computer < Player
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end

class Game
  CHOICES = {'p' => 'Paper', 'r' => 'Rock', 's' => 'Scissors'}
  
  attr_reader :player, :computer

  def initialize
    @player = Human.new("Aaron")
    @computer = Computer.new("R2D2")
  end

  def compare_hands
    if player.hand == computer.hand
      puts "It's a Tie!"
    elsif player.hand > computer.hand
      player.hand.display_winning_message
      puts "#{player.name} Wins!"
    else
      computer.hand.display_winning_message
      puts "You Lose :("
    end
  end

  def play_again?
    begin
    puts "Would you like to play again? (y/n)"
    answer = gets.chomp.downcase
    end until answer == 'y' || answer == 'n' 

    if answer == 'y'
      game = Game.new.play
    else
      exit
    end
  end

  def play
    player.pick_hand
    computer.pick_hand
    compare_hands
    play_again?
  end
end

game = Game.new.play



