Camera = require("libs/camera")
require("src/algorithms/fov")
require("src/algorithms/animation")
require("src/entities/pc")
require("src/entities/game_manager")
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
    if not Game.player.dead then
        if Game.player:takeTurn() then
            Game.characters:takeTurns()
            computeFOV(Game.map, Game.player.tileX, Game.player.tileY, VIEW_RADIUS)
            self:centerCamera()
            Game.characters:clearDead()

            if Game.player.dead then
                Log.log("\nYou die!")
            end
        end

        if love.keyboard.isPressed("a") then
            Game.map:exploreAll()
        end

        gAnimation.update(dt)
    end
end

function mainState:draw()
    self.camera:attach()
        Game.map:draw()
        Game.objects:draw()
        Game.characters:draw()
        Game.player:draw()
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
