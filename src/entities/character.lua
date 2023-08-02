Class = require("libs/class")
require("src/entities/game_object")

Character = Class{}

function Character:init(defs)
    local enemyDef = db.enemies[defs.id]
    self.sprite = Sprite({
        texture1 = enemyDef.texture1,
        texture2 = enemyDef.texture2,
        quadX = enemyDef.quadX,
        quadY = enemyDef.quadY
    })
end

function Character:update(dt)
    self.sprite.x = self.tileX * TILE_W
    self.sprite.y = self.tileY * TILE_H
end

function Character:draw(map)
    if map:isVisible(self.tileX, self.tileY) then
        self.sprite:draw()
    end
end
