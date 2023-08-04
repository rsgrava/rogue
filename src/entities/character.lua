Class = require("libs/class")
require("src/utils")
require("src/algorithms/astar")
require("src/entities/sprite")

Character = Class{}

function Character:init(defs)
    local def = db.characters[defs.id]
    self.name = def.name
    self.sprite = Sprite({
        texture1 = def.texture1,
        texture2 = def.texture2,
        quadX = def.quadX,
        quadY = def.quadY
    })
    self.tileX = defs.tileX
    self.tileY = defs.tileY
    self.blocks = true

    self.hp = def.hp
    self.atk = def.atk
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

function Character:tryAttack(dx, dy)
    local target = getObjectAt(self.tileX + dx, self.tileY + dy)
    if target then
        self:attack(target)
        return true
    else
        return false
    end
end

function Character:tryMoveOrAttack(dx, dy)
    if self:tryMove(dx, dy) then
        return true
    end
    return self:tryAttack(dx, dy)
end

function getObjectAt(x, y)
    for objectId, object in pairs(gObjects) do
        if object.tileX == x and object.tileY == y then
            return object
        end
    end
end

function Character:moveTowards(x, y)
    local path = astar(gMap, self.tileX, self.tileY, x, y)
    if path and #path > 1 then
        self:tryMove(path[2].x - self.tileX, path[2].y - self.tileY)
    else
        local dx = x - self.tileX
        local dy = y - self.tileY
        local distance = math.sqrt(dx^2 + dy^2)
        
        dx = math.round(dx / distance)
        dy = math.round(dy / distance)

        self:tryMove(dx, dy)
    end
end

function Character:moveAwayFrom(x, y)
    local dx = self.tileX - x
    local dy = self.tileY - y
    local distance = math.sqrt(dx^2 + dy^2)
    
    dx = math.round(dx / distance)
    dy = math.round(dy / distance)

    self:tryMove(dx, dy)
end

function Character:distanceTo(x, y)
    return math.sqrt((x - self.tileX)^2 + (y - self.tileY)^2)
end

function Character:attack(target)
    local dmg = self.atk
    Log.log(self.name.." attacks "..target.name.." for "..dmg.." damage!")
    target:takeDamage(self.atk)
end

function Character:takeDamage(dmg)
    self.hp = self.hp - dmg
    if self.hp <= 0 then
        self:die()
    end
end

function Character:die()
    Log.log(self.name.." is minced!")
    self.dead = true
end
