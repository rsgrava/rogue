Camera = require("libs/camera")
require("src/core/global_animation")

mainState = {}

function mainState:init()
end

function mainState:enter()
    self.camera = Camera()
end

function mainState:leave()
end

function mainState:resume()
end

function mainState:update(dt)
    GlobalAnimation.update(dt)
end

function mainState:draw()
    self.camera:attach()
    self.camera:detach()
end
