Class = require("libs/class")
require("src/entities/sprite")

Item = Class{}

function Item:init(id)
    local def = db.items[id]
    self.sprite = Sprite({
        texture1 = def.texture,
        quadX = def.quadX,
        quadY = def.quadY
    })
end

function Item:draw(x, y)
    self.sprite:draw(x, y)
end
