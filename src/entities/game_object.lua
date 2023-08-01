Class = require("libs/class")
require("src/core/drawable")

GameObject = Class{
    __includes = Drawable
}

function GameObject:init(defs)
    Drawable.init(self, defs.texture1, defs.texture2, defs.quadX, defs.quadY)
    self.tileX = defs.tileX
    self.tileY = defs.tileY
end

function GameObject:update(dt)
    self.x = self.tileX * TILE_W
    self.y = self.tileY * TILE_H
end
