Class = require("libs/class")
require("src/entities/game_object")

Enemy = Class{
    __includes = GameObject
}

function Enemy:init(defs)
    local enemyDef = db.enemies[defs.id]
    defs.texture1 = enemyDef.texture1
    defs.texture2 = enemyDef.texture2
    defs.quadX = enemyDef.quadX
    defs.quadY = enemyDef.quadY
    GameObject.init(self, defs)
end

function Enemy:update(dt)
    GameObject.update(self)
end

function Enemy:draw(map)
    if map:isVisible(self.tileX, self.tileY) then
        Drawable.draw(self)
    end
end
