Camera = require("libs/camera")
require("src/algorithms/dungeon_generator")
require("src/algorithms/fov")
require("src/algorithms/global_animation")
require("src/entities/player_character")
require("src/ui/log")

mainState = {}

function mainState:init()
end

function mainState:enter()
    self.camera = Camera()
    gMap, gObjects, startX, startY = generateDungeon({
        width = 100,
        height = 100,
        minRooms = 20,
        maxRooms = 30,
        minSize = 6,
        maxSize = 10
    })

    gPlayer = PlayerCharacter({
        id = "player",
        tileX = startX,
        tileY = startY
    })

    self:centerCamera()
    computeFOV(gMap, gPlayer.tileX, gPlayer.tileY, VIEW_RADIUS)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    if not gPlayer.dead then
        if gPlayer:takeTurn() then
            for objectId, object in pairs(gObjects) do
                object:takeTurn()
            end
            computeFOV(gMap, gPlayer.tileX, gPlayer.tileY, VIEW_RADIUS)
            self:centerCamera()

            local removal = {}
            for objectId, object in pairs(gObjects) do
                if object.dead then
                    table.remove(gObjects, objectId)
                end
            end

            if gPlayer.dead then
                Log.log("\nYou die!")
            end
        end
        GlobalAnimation.update(dt)
    end
end

function mainState:draw()
    self.camera:attach()
        gMap:draw()
        gPlayer:draw()
        for objectId, object in pairs(gObjects) do
            object:draw()
        end
    self.camera:detach()
    Log.draw()
end

function mainState:centerCamera()
    local camX = gPlayer.tileX * TILE_W + (TILE_W - GAME_W) / 2
    local camY = gPlayer.tileY * TILE_H + (TILE_H - GAME_H) / 2
    local mapWidth = gMap.width * TILE_W
    local mapHeight = gMap.height * TILE_W

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
