require("src/algorithms/global_animation")

Sprite = Class{}

function Sprite:init(defs)
    self.texture1 = defs.texture1
    self.texture2 = defs.texture2
    self.quad = love.graphics.newQuad(defs.quadX * TILE_W, defs.quadY * TILE_H,
        TILE_W, TILE_H, defs.texture1)
end

function Sprite:draw(x, y)
    local texture = self.texture1
    if GlobalAnimation.frame == 2 and self.texture2 ~= nil then
        texture = self.texture2
    end

    love.graphics.draw(
        texture,
        self.quad,
        x,
        y
    )
end
