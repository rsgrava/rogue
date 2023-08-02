Class = require("libs/class")

Enemy = Class{}

function Enemy:init(defs)
    local enemyDef = db.enemies[defs.id]
    defs.texture1 = enemyDef.texture1
    defs.texture2 = enemyDef.texture2
    defs.quadX = enemyDef.quadX
    defs.quadY = enemyDef.quadY
    self.sprite = Sprite({
        texture1 = enemyDef.texture1,
        texture2 = enemyDef.texture2,
        quadX = enemyDef.quadX,
        quadY = enemyDef.quadY
    })
    self.tileX = defs.tileX
    self.tileY = defs.tileY
    self.blocks = true
end

function Enemy:update(dt)
end

function Enemy:draw(map)
    if map:isVisible(self.tileX, self.tileY) then
        self.sprite:draw(self.tileX * TILE_W, self.tileY * TILE_H)
    end
end
