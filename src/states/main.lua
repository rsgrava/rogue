Camera = require("libs/camera")
require("src/core/global_animation")
require("src/dungeon_generator")
require("src/entities/game_object")
require("src/fov")

mainState = {}

function mainState:init()
end

function mainState:enter()
    self.camera = Camera()
    self.map, startX, startY = generateDungeon({
        width = 100,
        height = 100,
        minRooms = 20,
        maxRooms = 30,
        minSize = 6,
        maxSize = 10
    })
    self.character = GameObject({
        texture1 = assets.graphics.Characters.Player0,
        texture2 = assets.graphics.Characters.Player1,
        quadX = 0,
        quadY = 0,
        tileX = startX,
        tileY = startY,
    })
    self.character:update()
    self:centerCamera()
    computeFOV(self.map, self.character.tileX, self.character.tileY, VIEW_RADIUS)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    local moved = false
    if love.keyboard.isPressed("up") then
        local newY = self.character.tileY - 1
        if self.map:canWalk(self.character.tileX, newY) then
            self.character.tileY = newY
            moved = true
        end
    elseif love.keyboard.isPressed("down") then
        local newY = self.character.tileY + 1
        if self.map:canWalk(self.character.tileX, newY) then
            self.character.tileY = newY
            moved = true
        end
    elseif love.keyboard.isPressed("left") then
        local newX = self.character.tileX - 1
        if self.map:canWalk(newX, self.character.tileY) then
            self.character.tileX = newX
            moved = true
        end
    elseif love.keyboard.isPressed("right") then
        local newX = self.character.tileX + 1
        if self.map:canWalk(newX, self.character.tileY) then
            self.character.tileX = newX
            moved = true
        end
    end

    if moved then
        self.character:update(dt)
        computeFOV(self.map, self.character.tileX, self.character.tileY, VIEW_RADIUS)
        self:centerCamera()
    end

    GlobalAnimation.update(dt)
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
