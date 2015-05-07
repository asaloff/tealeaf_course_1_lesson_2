require 'pry'

class Deck
  attr_accessor :current_deck

  def initialize
    @suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
    @cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    @current_deck = @cards.product(@suits)
  end
  
  def deal_card(player)
    player.hand << @current_deck.shift
  end

  def shuffle
    @current_deck.shuffle!
  end

end

class Player
  attr_accessor :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def calculate_one_card_total
    if @hand[0][0] == "A"
      11
    elsif @hand[0][0].to_i == 0 # J, Q, K
      10
    else
      @hand[0][0].to_i
    end
  end

  def calculate_total(cards) 
    arr = cards.map!{|e| e[0] }

    total = 0
    arr.each do |value|
      if value == "A"
        total += 11
      elsif value.to_i == 0 # J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end
    total
  end

  def show_one_card
    puts "The Dealer is showing the #{@hand[0][0]} of #{@hand[0][1]} for a total of #{calculate_one_card_total}"
  end
  
  def show_hand
    puts "#{@name} has the #{@hand[0][0]} of #{@hand[0][1]} and the #{@hand[1][0]} of #{@hand[1][1]} for a total of #{calculate_total(@hand)}"
  end
end


class Game
  def initialize
    @deck = Deck.new
    @player1 = Player.new('Aaron')
    @dealer = Player.new('Dealer')
  end
  

  # hit_or_stay?
  # blackjack?
  # over_blackjack?
  # compare_cards
  # declare_winner

  def play
    @deck.shuffle
    
    begin
    @deck.deal_card(@player1)
    @deck.deal_card(@dealer) 
    end until @player1.hand.count == 2 && @dealer.hand.count == 2
    @dealer.show_one_card
    @player1.show_hand
  end
end

game = Game.new.play






