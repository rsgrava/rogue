Camera = require("libs/camera")
require("src/algorithms/fov")
require("src/entities/game_manager")
require("src/entities/pc")
require("src/ui/log")
require("src/ui/overlay")

mainState = {}

function mainState:init()
end

function mainState:enter()
    Game.init()
    self.camera = Camera()
    self.camera.smoother = Camera.smooth.linear(100)
    self:centerCamera()
    computeFOV(Game.map, Game.player.tileX, Game.player.tileY, VIEW_RADIUS)
    UIManager.insert(Overlay)
    UIManager.insert(Log)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    if love.keyboard.isPressed("d") then
        UIManager.clear()
    end
    if love.mouse.wheelMoved() == "up" then
        tileScale = math.min(tileScale + 1, 5)
    elseif love.mouse.wheelMoved() == "down" then
        tileScale = math.max(1, tileScale - 1)
    end
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
end

function mainState:centerCamera()
    local camX = Game.player.tileX * TILE_W * tileScale + TILE_W / 2 * tileScale - (GAME_W / (TILE_W * tileScale) - BORDER_RIGHT - BORDER_LEFT) * TILE_W * tileScale / 2
    local camY = Game.player.tileY * TILE_H * tileScale + TILE_H / 2 * tileScale - (GAME_H / (TILE_H * tileScale) - BORDER_BOTTOM - BORDER_TOP) * TILE_H * tileScale / 2
    local mapWidth = (Game.map.width + BORDER_RIGHT + BORDER_LEFT) * TILE_W * tileScale 
    local mapHeight = (Game.map.height + BORDER_BOTTOM + BORDER_TOP) * TILE_W * tileScale

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
