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
        tileX = 1,
        tileY = 1,
    })
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    if love.keyboard.isPressed("up") then
        local newY = self.character.tileY - 1
        if self.map:canWalk(self.character.tileX, newY) then
            self.character.tileY = newY
        end
    elseif love.keyboard.isPressed("down") then
        local newY = self.character.tileY + 1
        if self.map:canWalk(self.character.tileX, newY) then
            self.character.tileY = newY
        end
    elseif love.keyboard.isPressed("left") then
        local newX = self.character.tileX - 1
        if self.map:canWalk(newX, self.character.tileY) then
            self.character.tileX = newX
        end
    elseif love.keyboard.isPressed("right") then
        local newX = self.character.tileX + 1
        if self.map:canWalk(newX, self.character.tileY) then
            self.character.tileX = newX
        end
    end
    self.character:update(dt)
    GlobalAnimation.update(dt)
    self:centerCamera()
end

function mainState:draw()
    self.camera:attach()
        self.map:draw()
        self.character:draw()
    self.camera:detach()
end

function mainState:centerCamera()
    local camX = self.character.x + (TILE_W - GAME_W) / 2
    local camY = self.character.y + (TILE_H - GAME_H) / 2
    local mapWidth = self.map.width * TILE_W
    local mapHeight = self.map.height * TILE_W

    if camX < 0 then
        camX = 0
    end
    if camX + GAME_W > mapWidth then
        if mapWidth < GAME_W then
            camX = (mapWidth - GAME_W) / 2
        else
            camX = mapWidth - GAME_W
        end
    end

    if camY < 0 then
        camY = 0
    end
    if camY + GAME_H > mapHeight then
        if mapHeight < GAME_H then
            camY = (mapHeight - GAME_H) / 2
        else
            camY = mapHeight - GAME_H
        end
    end

    self.camera:lookAt(math.floor(camX + love.graphics.getWidth() / 2), math.floor(camY + love.graphics.getHeight() / 2))
end
