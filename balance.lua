Balance = Object:extend()

function Balance:new()
    self.balance = player_balance
    self.x = 905
    self.y = 50
    self.width = 200
    self.height = 50
    self.text = string.format("Balance: $%d", self.balance)
    self.font = love.graphics.newFont(20)
end

function Balance:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x + 13, self.y + 13)
end

