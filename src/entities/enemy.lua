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

function Enemy:takeTurn(map, player, objects)
    self.ai(self, map, player, objects)
end
