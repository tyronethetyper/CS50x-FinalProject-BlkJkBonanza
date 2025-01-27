Graphic = Object:extend()

math.randomseed(os.time())

graphics = {}

function Graphic:new(x, y, img)
    self.x = x
    self.y = y
    self.img = img
end

function Graphic:draw()
    love.graphics.draw(self.img, self.x, self.y)
    -- love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
end


