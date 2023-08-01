Camera = require("libs/camera")
require("src/core/global_animation")
require("src/map")
require("src/entities/game_object")

mainState = {}

function mainState:init()
end

function mainState:enter()
    self.camera = Camera()
    self.map = Map()
    self.character = GameObject({
        texture1 = assets.graphics.Characters.Player0,
        texture2 = assets.graphics.Characters.Player1,
        quadX = 0,
        quadY = 0,
        tileX = 0,
        tileY = 0,
    })
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    if love.keyboard.isPressed("up") then
        self.character.tileY = self.character.tileY - 1
    elseif love.keyboard.isPressed("down") then
        self.character.tileY = self.character.tileY + 1
    elseif love.keyboard.isPressed("left") then
        self.character.tileX = self.character.tileX - 1
    elseif love.keyboard.isPressed("right") then
        self.character.tileX = self.character.tileX + 1
    end
    self.character:update(dt)
    GlobalAnimation.update(dt)
end

function mainState:draw()
    self.camera:attach()
        self.map:draw()
        self.character:draw()
    self.camera:detach()
end
