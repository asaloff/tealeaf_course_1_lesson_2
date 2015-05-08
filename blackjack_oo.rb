require 'pry'

module Design
  
  def display_long_line
    puts "____________________________________" 
  end

  def display_short_line
    puts "----------"
  end

  def puts_with_arrow message
    puts "=> #{message}"
  end

end

module CardValue
  include Design

  def calculate_total(cards) 
    arr = cards.map { |e| e[0] }

    total = 0
    arr.each do |value|
      if value == "Ace"
        total += 11
      elsif value.to_i == 0 # J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end

    if arr.any? { |card| card.include?("Ace") }
      arr.each do |card|
        total -= 10 if total > Game::BLACKJACK && card.include?("Ace")
      end
    end
    total
  end

  def show_next_card(player)
    system 'clear'
    puts_with_arrow "#{player.name} was dealt a #{player.hand.last[0]} of #{player.hand.last[1]}"
  end

end


class Deck

  attr_accessor :current_deck

  def initialize
    @suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
    @cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
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

  include Design
  include CardValue

  attr_accessor :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def show_hand
    display_long_line
    puts "#{@name} has the following cards:"
    @hand.each { |card| puts_with_arrow "The #{card[0]} of #{card[1]}" }
    display_short_line
    puts "Total: #{calculate_total(@hand)}"
    display_short_line
  end

  def bust?
    return true if calculate_total(@hand) > Game::BLACKJACK
  end

  def blackjack?
    return true if calculate_total(@hand) == Game::BLACKJACK
  end
end

class Dealer < Player

  attr_accessor :hand
  attr_reader :name

  def initialize
    @name = 'Dealer'
    @hand = []
  end

  def calculate_one_card_total
    if @hand[0][0] == "Ace"
      11
    elsif @hand[0][0].to_i == 0 # J, Q, K
      10
    else
      @hand[0][0].to_i
    end
  end

  def show_one_card
    system 'clear'
    display_long_line
    puts "The Dealer is showing the #{@hand[0][0]} of #{@hand[0][1]}"
    display_short_line
    puts "Total: #{calculate_one_card_total}"
    display_short_line
  end

  def flip_second_card
    system 'clear'
    display_long_line
    puts "The Dealer flipped a #{@hand[1][0]} of #{@hand[1][1]}"
  end

  def must_hit?
    return true if calculate_total(@hand) < Game::DEALER_MUST_HIT
  end

end

class Game

  BLACKJACK = 21
  DEALER_MUST_HIT = 17

  include Design
  include CardValue

  def initialize
    @deck = Deck.new
    @player1 = Player.new('Aaron')
    @dealer = Dealer.new
  end
  
  def winner(player)
    if player == 'Dealer'
      puts "Dealer Wins...Bummer"
    elsif player == 'tie'
      puts "it's a Tie!!"
    else
      puts "You Win!!"
    end
  end

  def hit_or_stay(player)
    begin
      choice = nil
      until choice == 'stay' || choice == 'hit'
        puts "What would you like to do: 'hit' or 'stay'?"
        choice = gets.chomp.downcase
      end 

      if choice == 'hit'
        @deck.deal_card(player)
        show_next_card(player)
        player.show_hand
      end

      check_bust_or_blackjack(player)

    end until choice == 'stay'
  end


  def check_bust_or_blackjack(player)
    if player.bust?
      puts "#{player.name} busts!"
      if player.name == 'Dealer'
        winner('player')
        display_long_line
      else
        winner('Dealer')
        display_long_line
      end
      replay_or_end
    elsif player.blackjack?
      puts "#{player.name} has Blackjack!!"
      if player.name == 'Dealer'
        winner('Dealer')
        display_long_line
      else
        winner('player')
        display_long_line
      end
      replay_or_end
    end
  end

  def compare_cards
    if @player1.calculate_total(@player1.hand) > @dealer.calculate_total(@dealer.hand)
      puts "#{@player1.name}'s cards are better"
      winner('player')
      display_long_line
    else
      puts "Dealer's cards are better"
      winner('Dealer')
      display_long_line
    end
  end

  def replay_or_end
    puts "Would you like to play again? 'y'/'n'"
    answer = gets.chomp.downcase
    if answer == 'y'
      Game.new.play
    else
      exit
    end
  end

  def play
    @deck.shuffle
    
    begin
      @deck.deal_card(@player1)
      @deck.deal_card(@dealer) 
    end until @player1.hand.count == 2 && @dealer.hand.count == 2
 
    @dealer.show_one_card
    @player1.show_hand

    check_bust_or_blackjack(@player1)

    hit_or_stay(@player1)

    @dealer.flip_second_card
    @dealer.show_hand
    check_bust_or_blackjack(@dealer)
    sleep 3

    while @dealer.must_hit?
      puts "Dealer hits"
      @deck.deal_card(@dealer)
      @dealer.show_hand
      check_bust_or_blackjack(@dealer)
      sleep 3
    end

    compare_cards
    replay_or_end
  end
end

Game.new.play


