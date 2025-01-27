function love.load()
    Object = require "classic"
    require "cards"
    require "buttons"
    require "balance"
    require "bets"
    require "graphics"

    -- Load assets
    background = love.graphics.newImage("blackjack_table-1.png")
    bust_img = love.graphics.newImage("Assets/bust.png")
    dealer_bust_img = love.graphics.newImage("Assets/dealer_bust.png")
    player_bust = love.graphics.newImage("Assets/you_lose.png")
    win_img = love.graphics.newImage("Assets/win.png")
    lose_img = love.graphics.newImage("Assets/lose.png")
    tie_img = love.graphics.newImage("Assets/tie.png")
    blackjack_img = love.graphics.newImage("Assets/blackjack.png")
    screen_width = love.graphics.getWidth()
    -- Permanent Variables
    player_balance = 10000
    -- Start a new game
    resetGame()


end

function love.update()
  
    if not game_over then
    
      if is_busted then
          table.insert(graphics, Graphic((screen_width - dealer_bust_img:getWidth()) / 2 + 100, 320, player_bust))
          updateBalance(-1*bet_amount)
          game_over = true
          reset_button()
      elseif split_1_bust  and not split1BustHandled then
        updateBalance(-1*bet_amount)
        table.insert(graphics, Graphic(split_cards_1[1].x - (bust_img:getWidth() / 2), 320, bust_img))
        split1BustHandled = true
      elseif split_2_bust and not split2BustHandled then
        updateBalance(-1*bet_amount)
        table.insert(graphics, Graphic(split_cards_2[1].x, 320, bust_img))
        split2BustHandled = true
      end
      
      if split1BustHandled and split2BustHandled then
        total_split_bust = true
        game_over = true
        reset_button()
      end
      
      if player_blackjack and not dealer_blackjack then
          table.insert(graphics, Graphic((screen_width - blackjack_img:getWidth()) / 2, 320, blackjack_img))
          updateBalance(bet_amount*1.5)
          game_over = true
          reset_button()
      elseif dealer_blackjack and player_blackjack then
          dealer_cards[2].image = love.graphics.newImage(dealer_cards[2].path)
          table.insert(graphics, Graphic((screen_width - tie_img:getWidth()) / 2, 320, tie_img))
          game_over = true
          reset_button()
      end
      
      if dealer_bust and not split then
          table.insert(graphics, Graphic((screen_width - dealer_bust_img:getWidth()) / 2, 320, dealer_bust_img))
          updateBalance(bet_amount)
          game_over = true
          reset_button()
      elseif dealer_bust and split then
          if not split1BustHandled then
            table.insert(graphics, Graphic(split_cards_1[2].x - (win_img:getWidth() / 2), 320, win_img))
            updateBalance(bet_amount)
          end
          if not split2BustHandled then
            table.insert(graphics, Graphic(split_cards_2[1].x, 320, win_img))
            updateBalance(bet_amount)
          end
          game_over = true
          reset_button()
      end
      
      if dealer_blackjack and not player_blackjack  and not split and not game_over and dealer_finished then
          dealer_cards[2].image = love.graphics.newImage(dealer_cards[2].path)
          table.insert(graphics, Graphic((screen_width - lose_img:getWidth()) / 2, 320, lose_img))
          updateBalance(-1*bet_amount)
          game_over = true
          reset_button()
     elseif dealer_blackjack and split and not game_over and dealer_finished then
          dealer_cards[2].image = love.graphics.newImage(dealer_cards[2].path)
          if not split1BustHandled then
            table.insert(graphics, Graphic(split_cards_1[2].x - (lose_img:getWidth() / 2), 320, lose_img))
            updateBalance(-1*bet_amount)
          end
          if not split2BustHandled then
            table.insert(graphics, Graphic(split_cards_2[1].x, 320, lose_img))
            updateBalance(-1*bet_amount)
          end
          game_over = true
          reset_button()
    end
      
    if dealer_finished and not dealer_bust and not game_over then
      if not split then
        win_lose_check(scores, "player_score")
      end
      if not split_1_bust and not split1BustHandled and split then
        win_lose_check(scores, "split_1_score")
      end
      if not split_2_bust and not split2BustHandled and split then
        win_lose_check(scores, "split_2_score")
      end
      game_over = true
      reset_button()
    end
  end
end

function love.draw()
    
    love.graphics.draw(background, 0, 0)
    for i, button in ipairs(buttons) do
        button:draw()
    end
    for i, card in ipairs(player_cards) do
        card:draw()
    end
    for i, card in ipairs(dealer_cards) do
        card:draw()
    end
    for i, card in ipairs(split_cards_1) do
        card:draw()
    end
    for i, card in ipairs(split_cards_2) do
        card:draw()
    end
    for i, graphic in ipairs(graphics) do
        graphic:draw()
    end
    

    balance_block:draw()
    bet_block:draw()

end


function love.mousepressed(x, y, buttonIdx, isTouch)
    if buttonIdx == 1 then  -- Left mouse button
        for i, button in ipairs(buttons) do
            if button:isClicked(x, y) then
                if button.text == 'Deal me in!' then
                    for i = 1, 2 do
                        local player_card = Card(p_start_x, p_start_y, "player")
                        player_card.card_id = 10
                        table.insert(player_cards, player_card)
                        scores["player_score"] = scores["player_score"]  + player_card.card_value
                        if scores["player_score"] == 21 then
                          player_blackjack = true
                        end
                    end
                    for j = 1, 2 do
                        if j == 2 then
                            local dealer_card = Card(d_start_x, d_start_y, "dealer")
                            dealer_card.image = love.graphics.newImage("Classic/card back 2.png")
                            table.insert(dealer_cards, dealer_card)
                            dealer_score = dealer_score + dealer_card.card_value
                            if dealer_score == 21 then
                              dealer_blackjack = true
                            end
                            break
                        end
                        local dealer_card = Card(d_start_x, d_start_y, "dealer")
                        table.insert(dealer_cards, dealer_card)
                        dealer_score = dealer_score + dealer_card.card_value
                    end
                    buttons = {}
                    table.insert(buttons, Button(300, 670, 200, 50, "Hit"))
                    table.insert(buttons, Button(550, 670, 200, 50, "Stay.."))
                    if player_cards[1].card_id == player_cards[2].card_id then
                        table.insert(buttons, Button(425, 740, 200, 50, "Split"))
                    end
                end

                if button.text == 'Hit' then
                    if split_first and split then
                        split_1_x = split_1_x - 50
                        local split_card = Card(split_1_x, p_start_y, "player")
                        table.insert(split_cards_1, split_card)
                        scores["split_1_score"] = scores["split_1_score"] + split_card.card_value
                        checkPlayerHand(split_cards_1, scores, "split_1_score")
                    elseif split_second  and split then
                        split_2_x = split_2_x + 50
                        local split_card = Card(split_2_x, p_start_y, "player")
                        table.insert(split_cards_2, split_card)
                        scores["split_2_score"] = scores["split_2_score"] + split_card.card_value
                        checkPlayerHand(split_cards_2, scores, "split_2_score")
                        if split_2_bust then
                          dealer_turn()
                        end
                    elseif not split then
                        local new_card = Card(p_start_x, p_start_y, "player")
                        table.insert(player_cards, new_card)
                        scores["player_score"] = scores["player_score"] + new_card.card_value
                        checkPlayerHand(player_cards, scores, "player_score")
                    end
                end

                if button.text == 'Stay..' then
                    if split_first and split then
                        split_first = false
                        split_second = true
                    elseif split_second and split then
                        split_second = false
                        dealer_turn()
                    else
                        dealer_turn()
                    end
                end

                if button.text == 'Split' then
                    player_cards[1].x = player_cards[1].x - 50
                    player_cards[2].x = player_cards[2].x + 50
                    split_1_x = player_cards[1].x - 50
                    split_2_x = player_cards[2].x + 50
                    table.insert(split_cards_1, player_cards[1])
                    table.insert(split_cards_2, player_cards[2])
                    local split_card_1 = Card(split_1_x, p_start_y, "player")
                    table.insert(split_cards_1, split_card_1)
                    local split_card_2 = Card(split_2_x, p_start_y, "player")
                    table.insert(split_cards_2, split_card_2)
                    scores["split_1_score"] = player_cards[1].card_value + split_card_1.card_value
                    scores["split_2_score"] = player_cards[2].card_value + split_card_2.card_value
                    split_first = true
                    split = true
                    removeButtonByText("Split")
                end

                if button.text == 'Reset' then
                    resetGame()
                end

                if button.text == '+' then
                    bet_amount = bet_amount + 50
                    bet_block = Bets()
                end

                if button.text == '-' then
                    if bet_amount > 0 then
                        bet_amount = bet_amount - 50
                    end 
                    bet_block = Bets()
                end
                
            end

        end
        
    end
end

function dealer_turn()
    buttons = {}
    dealer_cards[2].image = love.graphics.newImage(dealer_cards[2].path)
    if dealer_blackjack then
      dealer_finished = true
    end
    while not dealer_finished and not game_over do
        if dealer_score == 21 and #dealer_cards == 2 then
            dealer_finished = true
            dealer_blackjack = true
        elseif dealer_score < 17 then
            local dealer_card = Card(d_start_x, d_start_y, "dealer")
            table.insert(dealer_cards, dealer_card)
            dealer_score = dealer_score + dealer_card.card_value
        elseif dealer_score >= 17  and dealer_score <= 21 then
            dealer_finished = true
        else
            local dealer_end = true
            for i, card in ipairs(dealer_cards) do
                if card.card_value == 11 then
                    card.card_value = 1
                    dealer_score = dealer_score - 10
                    dealer_end = false
                    if dealer_score <= 21 then
                      break
                    end
                end
            end
            if dealer_end then
                dealer_bust = true
                dealer_finished = true
            end
        end   
    end
end

function resetGame()
    -- Reset game state variables
    scores = {
        player_score = 0,
        split_1_score = 0,
        split_2_score = 0
    }
    dealer_score = 0
    graphics = {}
    player_cards = {}
    split_cards_1 = {}
    split_cards_2 = {}
    dealer_cards = {}
    bet_amount = 50
    is_busted = false
    player_blackjack = false
    dealer_blackjack = false
    dealer_bust = false
    dealer_finished = false
    game_over = false
    split = false
    total_split_bust = false
    split_first = false
    split_second = false
    split_1_bust = false
    split_2_bust = false
    split1BustHandled = false
    split2BustHandled = false
    p_start_x = 500  -- Starting x position
    p_start_y = 460  -- Starting y position
    d_start_x = 500
    d_start_y = 200
    -- Objects
    balance_block = Balance()
    bet_block = Bets()
    make_card_pack()

    -- Recreate the buttons if needed
    buttons = {}
    table.insert(buttons, Button(500, 670, 200, 50, "Deal me in!"))
    table.insert(buttons, Button(100, 625, 30, 30, "+"))
    table.insert(buttons, Button(100, 735, 30, 30, "-"))
end

function reset_button()
    buttons = {}
    table.insert(buttons, Button(500, 670, 200, 50, "Reset"))
end

function updateBalance(amount)
    player_balance = player_balance + amount
end

function removeButtonByText(text)
    for i, button in ipairs(buttons) do
        if button.text == text then
            table.remove(buttons, i)
            break
        end
    end
end

function checkPlayerHand(cards, scoreTable, scoreKey)

    if scoreTable[scoreKey] > 21 then
        local aces = false
        for i, card in ipairs(cards) do
            if card.card_value == 11 then 
                card.card_value = 1
                scoreTable[scoreKey] = scoreTable[scoreKey] - 10
                aces = true
                if scoreTable[scoreKey] <= 21 then
                    break  -- Stop changing aces if score is okay
                end
            end
        end
        if not aces and not split and scoreKey == "player_score" then
            buttons = {}
            is_busted = true
        elseif not aces and scoreKey == "split_1_score" then
            split_first = false
            split_second = true
            split_1_bust = true
        elseif not aces and scoreKey == "split_2_score" then
            buttons = {}
            split_2_bust = true
        end
            
    end
end

function win_lose_check(scores, scoreKey)
  if not is_busted and not dealer_bust then
    if scores[scoreKey]  > dealer_score then
        if not split then
          table.insert(graphics, Graphic(((screen_width - win_img:getWidth()) / 2), 320, win_img))
          updateBalance(bet_amount)
          game_over = true
        elseif scoreKey == 'split_1_score' then
          table.insert(graphics, Graphic(split_cards_1[2].x - (win_img:getWidth() / 2), 320, win_img))
          updateBalance(bet_amount)
        elseif scoreKey == 'split_2_score' then
          table.insert(graphics, Graphic(split_cards_2[1].x, 320, win_img))
          updateBalance(bet_amount)
          game_over = true
        end
    elseif dealer_score > scores[scoreKey] or dealer_blackjack then
        if not split then
          table.insert(graphics, Graphic(((screen_width - lose_img:getWidth()) / 2), 320, lose_img))
          updateBalance(-1*bet_amount)
          game_over = true
        elseif scoreKey == 'split_1_score' then
          table.insert(graphics, Graphic(split_cards_1[2].x - (lose_img:getWidth() / 2), 320, lose_img))
          updateBalance(-1*bet_amount)
        elseif scoreKey == 'split_2_score' then
          table.insert(graphics, Graphic(split_cards_2[1].x, 320, lose_img))
          updateBalance(-1*bet_amount)
          game_over = true
        end
    elseif dealer_score == scores[scoreKey] then
        if not split then
          table.insert(graphics, Graphic(((screen_width - tie_img:getWidth()) / 2), 320, tie_img))
          game_over = true
        elseif scoreKey == 'split_1_score' then
          table.insert(graphics, Graphic(split_cards_1[2].x - (tie_img:getWidth() / 2), 320, tie_img))
        elseif scoreKey == 'split_2_score' then
          table.insert(graphics, Graphic(split_cards_2[1].x, 320, tie_img))
          game_over = true
        end
    end
    end
end