Camera = require("libs/camera")

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
end

function mainState:draw()
    self.camera:attach()
    self.camera:detach()
end
