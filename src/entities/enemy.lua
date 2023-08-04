Class = require("libs/class")
require("src/entities/character")

Enemy = Class{
    __includes = Character
}

function Enemy:init(defs)
    Character.init(self, defs)
    local def = db.characters[defs.id]
    self.takeTurn = def.ai
    self.state = "init"
end
