require("src/core/global_animation")

Drawable = Class{}

function Drawable:init(texture1, texture2, tileX, tileY)
    self.x = 0
    self.y = 0
    self.texture1 = texture1
    self.texture2 = texture2
    self.quad = love.graphics.newQuad(tileX * TILE_W, tileY * TILE_H, TILE_W, TILE_H, texture1)
end

function Drawable:draw()
    local texture = self.texture1
    if GlobalAnimation.frame == 2 then
        texture = self.texture2
    end

    love.graphics.draw(
        texture,
        self.quad,
        self.x,
        self.y
    )
end
