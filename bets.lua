Bets = Object:extend()

function Bets:new()
    self.x = 60
    self.y = 670
    self.width = 140
    self.height = 50
    self.text = string.format("Bet: $%d", bet_amount)
    self.font = love.graphics.newFont(20)
end

function Bets:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + 13, self.y + 13)
end
