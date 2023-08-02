Class = require("libs/class")
require("src/entities/character")

Enemy = Class{
    __includes = Character
}

function Enemy:init(defs)
    Character.init(self, defs)
    local def = db.characters[defs.id]
    self.ai = def.ai
end

function Enemy:update(dt)
end

function Enemy:draw(map)
    if map:isVisible(self.tileX, self.tileY) then
        self.sprite:draw(self.tileX * TILE_W, self.tileY * TILE_H)
    end
end
