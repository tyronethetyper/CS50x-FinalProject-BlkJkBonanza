Card = Object:extend()

math.randomseed(os.time())

local suits = {"d", "h", "s", "c"}
local card_numbers = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"}
card_pack = {}

function make_card_pack()
    card_pack = {}
    for _, suit in ipairs(suits) do
        for _, number in ipairs(card_numbers) do
            local card = suit .. number
            local card_value = tonumber(number)
            if card_value > 9 then
                card_value = 10
            end
            if card_value == 1 then
                card_value = 11
            end
            card_pack[card] = card_value
        end
    end
end

-- Print each card in the card_pack
for card, number in pairs(card_pack) do
    print(card .. " - " .. number)
end

-- Function to get all keys from a table
local function get_keys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

-- Function to get a random key from a table
local function get_random_key(t)
    local keys = get_keys(t)
    local random_index = math.random(#keys)
    return keys[random_index]
end

-- Function to get a random element (key-value pair) from a table
local function get_random_card(t)
    local key = get_random_key(t)
    local value = t[key]
    card_pack[key] = nil
    return key, value
end

player_cards = {}
dealer_cards = {}
p_start_x = 500  -- Starting x position
p_start_y = 460  -- Starting y position
d_start_x = 500
d_start_y = 200
local spacing = 50

function Card:new(x, y, type)
    local key, card_val = get_random_card(card_pack)
    local path = "Classic/" .. key .. ".png"
    self.card_id = tonumber(string.match(key, "%d+"))
    self.image = love.graphics.newImage(path)
    self.x = x
    self.y = y
    self.card_value = card_val
    self.type = type
    self.path = path
    self.right_x = x + (self.image:getWidth() * 0.1)
    if type == "player" then
        p_start_x = p_start_x + 50
    end
    if type == "dealer" then
        d_start_x = d_start_x + 50
    end
end

function Card:draw()
    love.graphics.draw(self.image, self.x, self.y, nil, 0.1, 0.1)
    -- love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
end


