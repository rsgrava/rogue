Class = require("libs/class")

--[[
WindowQuads = {
    top_left = love.graphics.newQuad( 1 * TILE_W, 7 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    top = love.graphics.newQuad( 2 * TILE_W, 7 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    top_right = love.graphics.newQuad( 3 * TILE_W, 7 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    left = love.graphics.newQuad( 1 * TILE_W, 8 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    middle = love.graphics.newQuad( 2 * TILE_W, 8 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    right = love.graphics.newQuad( 3 * TILE_W, 8 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    bottom_left = love.graphics.newQuad( 1 * TILE_W, 9 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    bottom = love.graphics.newQuad( 2 * TILE_W, 9 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
    bottom_right = love.graphics.newQuad( 3 * TILE_W, 9 * TILE_H, TILE_W, TILE_H, assets.graphics.GUI.GUI0),
}
]]

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
end

function Window:draw()
    for y = 0, self.h - 1 do
        for x = 0, self.w - 1 do
            local pos = "middle"
            if x == 0 and y == 0 then
                pos = "top_left"
            elseif x == self.w - 1 and y == 0 then
                pos = "top_right"
            elseif y == 0 then
                pos = "top"
            elseif y == self.h - 1 and x == 0 then
                pos = "bottom_left"
            elseif y == self.h - 1 and x == self.w - 1 then
                pos = "bottom_right"
            elseif x == 0 then
                pos = "left"
            elseif x == self.w - 1 then
                pos = "right"
            elseif y == self.h - 1 then
                pos = "bottom"
            end
            love.graphics.draw(
                assets.graphics.GUI.GUI0,
                WindowQuads[pos],
                self.x + x * TILE_W,
                self.y + y * TILE_H
            )
        end
    end
end
