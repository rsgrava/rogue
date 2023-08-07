Camera = require("libs/camera")
require("src/algorithms/fov")
require("src/entities/game_manager")
require("src/entities/pc")
require("src/ui/log")

mainState = {}

function mainState:init()
end

function mainState:enter()
    Game.init()
    self.camera = Camera()
    self:centerCamera()
    computeFOV(Game.map, Game.player.tileX, Game.player.tileY, VIEW_RADIUS)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    Game.update(dt)
    computeFOV(Game.map, Game.player.tileX, Game.player.tileY, VIEW_RADIUS)
    self:centerCamera()
    if love.keyboard.isPressed("a") then
        Game.map:exploreAll()
    end
    if love.keyboard.isPressed("b") then
        Game.scheduler:print()
    end
    if love.keyboard.isPressed("c") then
        Game.player.inv:print()
    end
end

function mainState:draw()
    self.camera:attach()
        Game.draw()
    self.camera:detach()
    Log.draw()
end

function mainState:centerCamera()
    local camX = Game.player.tileX * TILE_W + (TILE_W - GAME_W) / 2
    local camY = Game.player.tileY * TILE_H + (TILE_H - GAME_H) / 2
    local mapWidth = Game.map.width * TILE_W
    local mapHeight = Game.map.height * TILE_W

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
