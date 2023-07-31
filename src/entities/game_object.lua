Class = require("libs/class")
require("src/core/drawable")

GameObject = Class{
    __includes = Drawable
}

function GameObject:init(defs)
    Drawable.init(self, defs.texture1, defs.texture2, defs.tileX, defs.tileY)
    self.tileX = 0
    self.tileY = 0
end

function GameObject:update(dt)
    self.x = self.tileX * TILE_W
    self.y = self.tileY * TILE_H
end
