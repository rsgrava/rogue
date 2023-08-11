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
   Game.update(dt)
end

function mainState:draw()
    Game.draw()
end
