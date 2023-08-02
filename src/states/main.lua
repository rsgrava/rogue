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
    self.map, self.objects, startX, startY = generateDungeon({
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
    for objectId, object in pairs(self.objects) do
        object:update()
    end
    self:centerCamera()
    computeFOV(self.map, self.character.tileX, self.character.tileY, VIEW_RADIUS)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    local newX = self.character.tileX
    local newY = self.character.tileY
    if love.keyboard.isPressed("kp7") then
        newX = newX - 1
        newY = newY - 1
    elseif love.keyboard.isPressed("kp9") then
        newX = newX + 1
        newY = newY - 1
    elseif love.keyboard.isPressed("kp1") then
        newX = newX - 1
        newY = newY + 1
    elseif love.keyboard.isPressed("kp3") then
        newX = newX + 1
        newY = newY + 1
    elseif love.keyboard.isPressed("up") or love.keyboard.isPressed("kp8") then
        newY = newY - 1
    elseif love.keyboard.isPressed("down") or love.keyboard.isPressed("kp2") then
        newY = newY + 1
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        newX = newX - 1
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        newX = newX + 1
    end

    local moved = false
    if not self.map:isBlocked(self.objects, newX, newY) then
        self.character.tileX = newX
        self.character.tileY = newY
        moved = true
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
        for objectId, object in pairs(self.objects) do
            object:draw(self.map)
        end
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
