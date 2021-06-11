#Starting game prompts
puts "Welcome to ruby blackjack. What's your name?"

#save user input in var to use to make new player 
human_name = gets.chomp
puts "Hello #{human_name}, nice to meet you!"

#Classes: 
class Player
    attr_accessor :name
    attr_accessor :bankroll
    attr_accessor :hand

    def initialize name, bankroll
        @name = name
        @bankroll = bankroll
        @hand = []
    end

    #add cards
    def add_hand cards
        card_val = cards.map { |card| card.value}
        card_val.sum
    end

    #check bankroll
    def check_bank bet
        p bankroll - bet
    end
end

class Card 
    attr_accessor :value

    def initialize value
        #@value = whatever argument passed 
        @value = value 
    end

end


#Player instances 
human = Player.new human_name, 1000
the_house = Player.new "The House (dealer)", 10000

#tests
# puts human.name
# puts human.bankroll
# puts the_house.name
# puts the_house.bankroll

#Message to user - game rules 
puts "Lets get going. Here are the rules. You will get two cards. The goal is to beat The House by getting a hand as close to 21 as possible without 
going over. If you go over 21 or The House's hand is closer to 21 than yours, you lose your bet. Your bankroll starts at #{human.bankroll}, buy in is $10. Good luck!"

#CARDS
#create 52 instances - 4 sets of 13 cards  - add to deck 
#2-10 all = same # they are
#J Q K = 10
#A = 11

val_arr = [2,3,4,5,6,7,8,9,10,10,10,10,11]

#Fills deck with cards 
def fill_deck arr
    deck = []
    for num in 1..4 do 
        for val in arr do 
            deck << Card.new(val)
        end
    end
    deck
end

deck = fill_deck(val_arr)

# puts "The deck has #{deck.length} cards" 

#Game loop
until human.bankroll <= 0 do
  puts "What would you like to do? To quit enter q, to check bankroll enter bank or to deal enter any other key"
  human_choice = gets.chomp
#   puts human_choice
  
  #check bank 
  if human_choice === "bank"
    human.check_bank(0)
  elsif human_choice === "q"
    puts "Thanks for playing!"
    break
  else
    puts "Let's play!"

    #intial bet
    human_bet = 10

    #check deck length, if under 4 cards make a new deck
    if deck.length <= 3 
        deck = fill_deck(val_arr)
        # puts "deck has been refilled #{deck.length}"
    end

    #Each player gets two random cards:
    #shuffle deck: 
    deck.shuffle! 
 
    #human hand: 
    human.hand = deck.shift(2)
    # puts human.hand[0].value, human.hand[1].value

    #house hand: 
    the_house.hand = deck.shift(2)
    # puts the_house.hand[0].value, the_house.hand[1].value

    #sum of both hands 
    human_cards = human.add_hand(human.hand)
    the_house_cards = the_house.add_hand(the_house.hand)

    
    #stay or hit option 
    puts "Your cards equal #{human_cards}. Do you want to hit (enter h) or stay (enter any other key)?"

    input = gets.chomp

    #if choose hit 
    if input === "h" 
        #add one card to hand 
        human.hand.push(deck.shift())
        # puts human.hand
        #add total up 
        human_cards = human.add_hand(human.hand)
        # p human_cards
        #bust
        if human_cards > 21
            #subtract initial bet from bankroll if bust 
            human.bankroll -= 10
            the_house.bankroll += 10
            # p "human #{human.bankroll} and house #{the_house.bankroll}"
            p "Yikes, #{human_cards}....That's a bust, you lose!"
            break
        end
    else
        puts "Ok, sometimes you just have to play it safe."
    end
    
    #redefine total cards 
    human_cards = human.add_hand(human.hand)

    #raise from initial bet?
    puts "Your cards equal #{human_cards}, how much do you want to raise your bet? If you want to keep it the same, enter 0. To check your bankroll enter bank" 

    input = gets.chomp
  
    #check bank or bet 
    if input === "bank"
        human.check_bank(human_bet)
        puts "Your cards equal #{human_cards}, how much do you want to raise your bet? If you want to keep it the same, enter 0"
        input = gets.chomp  
        bet = input.to_i
        #new bet total 
        human_bet += bet
    else
        bet = input.to_i
        #new bet total 
        human_bet += bet
    # human.check_bank(human_bet)
    end
    
    puts "Great, your total bet is up to #{human_bet}. Let's go!"
    puts "............"
    
    #game logic: 

    #blackjack - win
    if human_cards === 21 
        the_house.bankroll -= human_bet 
        human.bankroll += human_bet 
        puts "Blackjack! You win with #{human_cards}, your bankroll is up to #{human.bankroll}"
    #busted - loss
    elsif human_cards > 21 
        the_house.bankroll += human_bet 
        human.bankroll -= human_bet
        puts "Busted! Sorry you went over 21 with #{human_cards}, your bankroll is down to #{human.bankroll}"
    #player hand > house - win 
    elsif human_cards > the_house_cards && human_cards <= 21 
        the_house.bankroll -= human_bet 
        human.bankroll += human_bet 
        puts "You win with a hand of #{human_cards} which beats the house hand of #{the_house_cards}! Your bankroll is up to #{human.bankroll}"
    #tie 
    elsif human_cards === the_house_cards
        puts "You tied The House, don't worry your bankroll is not affected"
    #house > player hand - loss 
    else
        the_house.bankroll += human_bet 
        human.bankroll -= human_bet
        puts "The house beats your hand of #{human_cards} with a hand of #{the_house_cards}. Your bankroll is down to #{human.bankroll}"
    end
  end
end

#Game over:
if human.bankroll <= 0 
    puts "Sorry, you are out of money game over!"
end


