Camera = require("libs/camera")
require("src/algorithms/dungeon_generator")
require("src/algorithms/fov")
require("src/algorithms/global_animation")
require("src/entities/character")

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

    self.player = Character({
        id = "player",
        tileX = startX,
        tileY = startY
    })

    self:centerCamera()
    computeFOV(self.map, self.player.tileX, self.player.tileY, VIEW_RADIUS)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    local moved
    if love.keyboard.isPressed("kp7") then
        moved = self.player:tryMove(self.map, self.objects, -1, -1)
    elseif love.keyboard.isPressed("kp9") then
        moved = self.player:tryMove(self.map, self.objects, 1, -1)
    elseif love.keyboard.isPressed("kp1") then
        moved = self.player:tryMove(self.map, self.objects, -1, 1)
    elseif love.keyboard.isPressed("kp3") then
        moved = self.player:tryMove(self.map, self.objects, 1, 1)
    elseif love.keyboard.isPressed("up") or love.keyboard.isPressed("kp8") then
        moved = self.player:tryMove(self.map, self.objects, 0, -1)
    elseif love.keyboard.isPressed("down") or love.keyboard.isPressed("kp2") then
        moved = self.player:tryMove(self.map, self.objects, 0, 1)
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        moved = self.player:tryMove(self.map, self.objects, -1, 0)
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        moved = self.player:tryMove(self.map, self.objects, 1, 0)
    end

    if moved then
        for objectId, object in pairs(self.objects) do
            object:takeTurn(self.map, self.player, self.objects)
        end
        computeFOV(self.map, self.player.tileX, self.player.tileY, VIEW_RADIUS)
        self:centerCamera()
    end

    GlobalAnimation.update(dt)
end

function mainState:draw()
    self.camera:attach()
        self.map:draw()
        self.player:draw(self.map)
        for objectId, object in pairs(self.objects) do
            object:draw(self.map)
        end
    self.camera:detach()
end

function mainState:centerCamera()
    local camX = self.player.tileX * TILE_W + (TILE_W - GAME_W) / 2
    local camY = self.player.tileY * TILE_H + (TILE_H - GAME_H) / 2
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
