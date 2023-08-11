Class = require("libs/class")
require("src/entities/sprite")

Item = Class{}

function Item:init(id)
    self.def = db.items[id]
    self.sprite = Sprite({
        texture1 = self.def.texture,
        quadX = self.def.quadX,
        quadY = self.def.quadY
    })
end

function Item:draw(x, y)
    self.sprite:draw(x, y)
end
