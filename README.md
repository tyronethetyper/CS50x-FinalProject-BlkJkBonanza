# Harvard CS50x Final Project - Blackjack Bonanza

Video Demo: https://youtu.be/dHK2g8vZg3k

Description:
Blackjack Bonanza is a Blackjack casino 1 vs 1 (player versus dealer) simulator game that applies all the rules, logic and probability perspectives as if you were playing at the actual casino. Players begin the game with a balance of $10,000 and from there can determine their fortune by playing and deciding how much to bet on each hand. The game also offers split functionality - allowing the player to choose whether to split cards when your initial two dealt cards are a pair (have the same value). The split functionality also follows the correct rules and logic in which you match your initial bet with your split hand and you are unable to achieve a natural Blackjack on your split hands.

Game Functionality:
'Deal Me in' Button
The 'Deal Me in' button starts a new hand when clicked by the user. Immediately after pressing the button the user in presented with their initial cards and are also shown one of the two dealer cards values - the other card being facedown.

In order to get the button to work I used the love.mousepressed method and an if statement to trigger when the text of the button clicked equals 'Deal Me in'. After triggering the correct if statement my code within goes about randomly drawing cards from a deck created within cards.lua and required within main.lua and adding these card objects to two object lists - being player_cards and dealer_cards. The code also during this process adds the respective card values, called on from their .card_value properties assigned when creating each card object, to the respective score within the scores list being either scores["player_score"] or scores["dealer_score"].

After completing these initial operations the code removes the dealer button and replaces it with buttons for the players next options - being either 'Hit', 'Stay' or 'Split' (should the cards be of a matching pair).

'Hit!' Button
The primary function of the hit button once called, which is triggered by the same logic as the 'Deal Me in' button, is to add a new random card from the remaining cards in the card deck and add this to the players cards list while also updating the players_score variable within the scores list.

The code finishes by calling the CheckPlayerHand function which is utilised to determine whether the players score is above 21, which would indicate they have gone bust and have therefore lost the game, but before concluding this going through the players cards to ensure there are no aces. If a player is over 21 in score and an ace is found the function updates the ace to have its alternative card value of 1 and updates the player score accordingly based on this. It will stop reducing aces to 1 when the players score is below 21. However if the player score is over 21 and there are no aces or all aces have already been converted to 1s then the player is bust and the is_busted variable is set to true.

When the is_busted variable is set to true this triggers an if statement in the love.update() function which updates the players balance accordingly, inserts the applicable 'Bust' graphic into the graphics list (to be drawn afterwards within the love.draw() function) and replaces the buttons with a 'Reset' button.

In the case of a player choosing to split the hit button performs the same functions - however it first allows the player the option to 'Hit' their cards to the left and then to the right after either going bust or choosing to 'Stay' on their first set of cards. I added functionality within the hit function so that cards are added on the left of the pile when hitting the cards on the left and on the right of the pile when hitting on the right - in order to avoid cards overlapping in the middle.

'Stay..' Button
The primary function of the 'Stay..' button is to allow the player the option to 'stand' when they have not gone bust and at the same time don't want to receive further cards.

The 'Stay..' button triggers the dealer_turn() function which is the function that is in charge of following the dealer rules and logic should a player still be active in the hand. The dealer_turn() function determines whether the dealer is below a card value score of 17 and if so adds a random card to dealer_cards and recalculates the dealer score. This continues until either the dealer reaches a score of at least 17 and equal to or less than 21 - or the dealer goes bust. In both the dealer_finished variable is set to true once the requirements are met and dealer_bust variable is set to true as well in the case of the dealer score being over 21. If the dealer_bust variable is set to true this triggers the necessary code within an if statement in love.update() that will update the players balance, insert the necessary 'Win' graphics into the graphics list and replace buttons with the 'Reset' button.

The 'Stay..' button functionality also takes into account splits and is able to apply the same logic as above to the the respective split hand the player is making a decision on.

'Split' Button
The primary function of the 'Split' button is to allow the player to split their cards should their initial two cards be a matching pair (have the same card value). The button will only show up on the game should the players cards match this criteria.

Once pressed code is triggered that splits the two cards into their own new lists, being split_1_cards and split_2_cards, and then adds a new random card from the card deck into each list. Their scores within the scores list, split_1_score and split_2_score, are updated with the new scores for each respective split pile. The split variable is updated to true in order to ensure correct handling within future functions and calls that are utilised in the game logic. Card positioning is updated on an object level in order for the user to see their cards being split on the screen and the additional cards added to each split pile.

'Reset' Button
The primary function of the 'Reset' button is to reset the game once the hand is over. This button only shows up once a result for the current hand has been reached - either a player win, loss or tie.

When the user presses the button the ResetGame() function is called which initializes core game variables and lists to their original state in order for a new hand to take place. It also updates the player balance graphic to update the new balance after the result of the previous hand. Furthermore it calls the make_card_pack() function which creates a new 52 card deck for the new hand.

Bet Amount Buttons
The '+' and '-' buttons around the bet amount box allow the user to increase or decrease their bet by $50 per click. After clicking either button the bet amount box will display the new current bet amount for that hand. Once the player has decided on amount and clicks 'Deal Me in' that bet amount is locked in for that hand and will determine how much they either win or lose in that hand - with an exception being a tie where no change occurs in the players balance unless it is split related.

Core Game Functions Used:
checkPlayerHand()
As mentioned previously the checkPlayerHand() function is called every time a player press the 'Hit' button to request an additional card being dealt. The function initially calculates and checks whether the players hand is over 21 in value. If it is it checks whether there are any aces in the hand that can be converted to the alternative value of 1 - and if there are stopping as soon as the player hand score is below or equal to 21. If there are no aces or all aces have already been converted then the function adjusts the relevant variable that either the players hand is bust in a normal case or that either/both split_1_cards and split_2_cards are bust in a split case.

win_lose_check(scores, scoreKey)
The win_lose_check function, which takes the scores list and the respective scoreKey (eg. "player_score") as arguments, is utilised at the end of the game after the deal_turn() function has finished but only in the case where the player is not bust, the dealer is not bust and neither player or dealer has a natural Blackjack.

The function analyses the final dealer score versus the players hand score to determine the winner or if it is a tie. After determining the game outcome the correct win/lose/tie graphics are added to the graphics list to be outputted to the screen in the love.draw() function. In the case of a win or loss it also updates the players balance by calling the updateBalance() function.

The function takes into account a split and analyses each split hand score separately against the dealer score while adding the correct win/loss/tie graphics to the graphics list to be outputted to the screen above the relevant split hand.

resetGame()
As mentioned previously the resetGame() function initializes core game variables and lists to their original state in order for a new hand to take place. It also updates the player balance graphic to update the new balance after the result of the previous hand. Furthermore it calls the make_card_pack() function which creates a new 52 card deck for the new hand.

The resetGame() function is called during the love.load() function to start the game and then is called whenever each hand is concluded and the player clicks the 'Reset' button.

updateBalance(amount)
The updateBalance function, which takes an integer amount as an argument, simply updates the players balance by the bet amount of the hand in question.

removeButtonByText(text)
The removeButtonByText function, which takes a text string as an argument, is utilised to clear buttons from the GUI when they are no longer required by removing them from the buttons list. As an example once the player clicks 'Split' the button is removed using removeButtonByText("Split") as you only have the ability to split your cards once.
