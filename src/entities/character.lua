Class = require("libs/class")
require("src/utils")
require("src/entities/sprite")

Character = Class{}

function Character:init(defs)
    local def = db.characters[defs.id]
    self.sprite = Sprite({
        texture1 = def.texture1,
        texture2 = def.texture2,
        quadX = def.quadX,
        quadY = def.quadY
    })
    self.tileX = defs.tileX
    self.tileY = defs.tileY
    self.blocks = true
end

function Character:draw()
    if gMap:isVisible(self.tileX, self.tileY) then
        self.sprite:draw(self.tileX * TILE_W, self.tileY * TILE_H)
    end
end

function Character:tryMove(dx, dy)
    if not gMap:isBlocked(self.tileX + dx, self.tileY + dy) then
        self.tileX = self.tileX + dx
        self.tileY = self.tileY + dy
        return true
    end
    return false
end


function Character:moveTowards(x, y)
    local dx = x - self.tileX
    local dy = y - self.tileY
    local distance = math.sqrt(dx^2 + dy^2)
    
    dx = math.round(dx / distance)
    dy = math.round(dy / distance)

    self:tryMove(dx, dy)
end

function Character:moveAwayFrom(x, y)
    local dx = self.tileX - x
    local dy = self.tileY - y
    local distance = math.sqrt(dx^2 + dy^2)
    
    dx = math.round(dx / distance)
    dy = math.round(dy / distance)

    self:tryMove(dx, dy)
end
