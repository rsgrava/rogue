Class = require("libs/class")
require("src/entities/sprite")

Character = Class{}

function Character:init(defs)
    self.tileX = defs.tileX
    self.tileY = defs.tileY
    self.sprite = Sprite({
        texture1 = defs.texture1,
        texture2 = defs.texture2,
        quadX = defs.quadX,
        quadY = defs.quadY
    })
end

function Character:draw()
    self.sprite:draw(self.tileX * TILE_W, self.tileY * TILE_H)
end
