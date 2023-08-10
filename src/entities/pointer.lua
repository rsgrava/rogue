Class = require("libs/class")

Pointer = Class{}

function Pointer:init(tileX, tileY)
    self.tileX = tileX
    self.tileY = tileY
end

function Pointer:update()
    if love.keyboard.isPressed("kp7") then
        self.tileX = self.tileX - 1
        self.tileY = self.tileY - 1
    elseif love.keyboard.isPressed("kp9") then
        self.tileX = self.tileX + 1
        self.tileY = self.tileY - 1
    elseif love.keyboard.isPressed("kp1") then
        self.tileX = self.tileX - 1
        self.tileY = self.tileY + 1
    elseif love.keyboard.isPressed("kp3") then
        self.tileX = self.tileX + 1
        self.tileY = self.tileY + 1
    elseif love.keyboard.isPressed("up") or love.keyboard.isPressed("kp8") then
        self.tileY = self.tileY -1
    elseif love.keyboard.isPressed("down") or love.keyboard.isPressed("kp2") then
        self.tileY = self.tileY + 1
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        self.tileX = self.tileX - 1
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        self.tileX = self.tileX + 1
    end
    self.tileX = math.max(math.min(self.tileX, Game.map.width - 1), 0)
    self.tileY = math.max(math.min(self.tileY, Game.map.height - 1), 0)
end

function Pointer:draw()
    love.graphics.rectangle(
        "line",
        self.tileX * TILE_W * tileScale,
        self.tileY * TILE_H * tileScale,
        TILE_W * tileScale,
        TILE_H * tileScale
    )
end
