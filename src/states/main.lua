Camera = require("libs/camera")
require("src/core/global_animation")
require("src/entities/game_object")

mainState = {}

function mainState:init()
end

function mainState:enter()
    self.camera = Camera()
    self.character = GameObject({
        texture1 = assets.graphics.Characters.Player0,
        texture2 = nil,
        quadX = 0,
        quadY = 0,
        tileX = 0,
        tileY = 0,
    })
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    self.character:update(dt)
    GlobalAnimation.update(dt)
end

function mainState:draw()
    self.camera:attach()
        self.character:draw(dt)
    self.camera:detach()
end
