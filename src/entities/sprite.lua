Sprite = Class{}

function Sprite:init(defs)
    self.texture1 = defs.texture1
    self.texture2 = defs.texture2
    self.quad = love.graphics.newQuad(defs.quadX * TILE_W, defs.quadY * TILE_H,
        TILE_W, TILE_H, defs.texture1)
end

function Sprite:draw(x, y, sx, sy)
    local texture = self.texture1
    if Game.animation.frame == 2 and self.texture2 ~= nil then
        texture = self.texture2
    end

    if sx == nil then
        sx = 1
    end
    if sy == nil then
        sy = 1
    end

    love.graphics.draw(
        texture,
        self.quad,
        x * tileScale,
        y * tileScale,
        0,
        tileScale * sx,
        tileScale * sy
    )
end
