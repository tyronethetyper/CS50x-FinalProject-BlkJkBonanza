Button = Object:extend()

function Button:new(x, y, width, height, text)
    self.x = x
    self.y = y 
    self.width = width
    self.height = height
    self.bgColor = {0, 0, 255}
    self.hoverColor = {128, 0, 0}
    self.clickColor = {128, 0, 0}
    self.textColor = {1, 1, 1}
    self.font = love.graphics.newFont(24)
    self.text = text
    self.radius = 10
end

function Button:draw()
    -- love.graphics.setColor(0, 0, 255)  -- Set color to white for the button rectangle
    -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    
    -- love.graphics.setColor(1, 1, 1)  -- Set color to black for the text
    -- local myFont = love.graphics.newFont(24)
    -- love.graphics.setFont(myFont)
    -- love.graphics.printf("Deal me in!", self.x, self.y + 10, self.width, "center")
    
    -- -- Reset color to white (or any color needed for subsequent drawings)
    

    local color = self.bgColor
    local mx, my = love.mouse.getPosition()
    local hovered = mx >= self.x and mx <= self.x + self.width and
                    my >= self.y and my <= self.y + self.height

    if hovered then
        color = love.mouse.isDown(1) and self.clickColor or self.hoverColor
    end

    love.graphics.setColor(color)
    --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    
    drawRoundedRectangle("fill", self.x, self.y, self.width, self.height, self.radius)

    -- Draw button text
    love.graphics.setColor(self.textColor)
    love.graphics.setFont(self.font)
    local textX = self.x + (self.width - self.font:getWidth(self.text)) / 2
    local textY = self.y + (self.height - self.font:getHeight()) / 2
    love.graphics.print(self.text, textX, textY)
    love.graphics.setColor(1, 1, 1)
end

function Button:isClicked(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
end

function drawRoundedRectangle(mode, x, y, width, height, radius, segments)
    segments = segments or 16
    -- Draw the rectangle's body
    love.graphics.rectangle(mode, x + radius, y, width - 2 * radius, height)
    love.graphics.rectangle(mode, x, y + radius, width, height - 2 * radius)

    -- Draw the four circles at the corners
    love.graphics.circle(mode, x + radius, y + radius, radius, segments)
    love.graphics.circle(mode, x + width - radius, y + radius, radius, segments)
    love.graphics.circle(mode, x + radius, y + height - radius, radius, segments)
    love.graphics.circle(mode, x + width - radius, y + height - radius, radius, segments)
end


