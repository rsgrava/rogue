Class = require("libs/class")
require("src/constants")

WindowQuads = {
    top_left = love.graphics.newQuad( 9 * TILE_W, 16 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    top = love.graphics.newQuad( 10 * TILE_W, 16 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    top_right = love.graphics.newQuad( 11 * TILE_W, 16 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    left = love.graphics.newQuad( 9 * TILE_W, 17 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    middle = love.graphics.newQuad( 10 * TILE_W, 17 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    right = love.graphics.newQuad( 11 * TILE_W, 17 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    bottom_left = love.graphics.newQuad( 9 * TILE_W, 18 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    bottom = love.graphics.newQuad( 10 * TILE_W, 18 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    bottom_right = love.graphics.newQuad( 11 * TILE_W, 18 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
}

Window = Class{}

function Window:init(defs)
    self.x = defs.x
    self.y = defs.y
    self.w = defs.w
    self.h = defs.h
    
    if defs.frameWidth then
        self.frameWidth = defs.frameWidth
    else
        self.frameWidth = 4
    end

    if defs.frameColor then
        self.frameColor = defs.frameColor
    else
        self.frameColor = COLORS.LIGHT_GRAY
    end

    if defs.rounded then
        self.rounded = defs.rounded
    else
        self.rounded = true
    end
end

function Window:draw()
    for y = 0, self.h - 1 do
        for x = 0, self.w - 1 do
            love.graphics.draw(
                assets.graphics.GUI.GUI0,
                WindowQuads.middle,
                self.x + x * TILE_W,
                self.y + y * TILE_H
            )
        end
    end

    love.graphics.setColor(self.frameColor)
    love.graphics.setLineWidth(self.frameWidth)
    love.graphics.rectangle(
        "line",
        self.x,
        self.y,
        self.w * TILE_W,
        self.h * TILE_H,
        self.rounded and TILE_W / 4 or 0,
        self.rounded and TILE_H / 4 or 0
    )
    love.graphics.setColor(COLORS.WHITE)
    love.graphics.setLineWidth(1)
end
