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
    computeFOV(Game.map, Game.player.tileX, Game.player.tileY, VIEW_RADIUS)
    UIManager.push(Overlay)
    UIManager.push(Log)
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    if love.mouse.wheelMoved() == "up" then
        tileScale = math.min(tileScale + 1, 5)
    elseif love.mouse.wheelMoved() == "down" then
        tileScale = math.max(1, tileScale - 1)
    end
    Game.update(dt)
    computeFOV(Game.map, Game.player.tileX, Game.player.tileY, VIEW_RADIUS)
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
    Game.draw()
end
