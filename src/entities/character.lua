Class = require("libs/class")
require("src/utils")
require("src/algorithms/astar")
require("src/entities/inventory")
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
    self.speed = def.speed

    self.inv = Inventory()
end

function Character:draw()
    if Game.map:isVisible(self.tileX, self.tileY) then
        self.sprite:draw(self.tileX * TILE_W, self.tileY * TILE_H)
    end
end

function Character:tryMove(dx, dy)
    if not Game.isBlocked(self.tileX + dx, self.tileY + dy) then
        self.tileX = self.tileX + dx
        self.tileY = self.tileY + dy
        return true
    end
    return false
end

function Character:tryAttack(dx, dy)
    local target = Game.characters:getAt(self.tileX + dx, self.tileY + dy)
    if target then
        self:attack(target)
        return true
    else
        return false
    end
end

function Character:tryMoveOrAttack(dx, dy)
    if self:tryMove(dx, dy) then
        return "move"
    end
    self:tryAttack(dx, dy)
    return "attack"
end

function Character:moveTowards(x, y)
    local path = astar(Game.map, self.tileX, self.tileY, x, y)
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

function Character:pickUpItem()
    local items = Game.objects:getAt(self.tileX, self.tileY)
    if items then
        if #items == 1 and items[1].count == 1 then
            self.inv:insert(items[1].item, 1)
            Game.objects:remove(items[1].item, 1)
        else
            Game.state = "menu"
            UIManager.push(
                InventoryScreen({
                    label = "Pick Up",
                    inv = Inventory(
                        items
                    ),
                    onSelect = function(slot)
                        if slot.count == 1 then
                            self.inv:insert(slot.item, 1)
                            Game.objects:remove(slot.item, 1)
                            UIManager.widgets[#UIManager.widgets]:calculatePages()
                            if #UIManager.widgets[#UIManager.widgets].pages[1] == 0 then
                                Game.state = "action"
                                UIManager.pop()
                            end
                        else
                            UIManager.push(
                                NumberSelect({
                                    max = slot.count,
                                    item = slot.item,
                                    onSelect = function(item, count)
                                        Game.player.inv:insert(item, count)
                                        Game.objects:remove(item, count)
                                        UIManager.pop()
                                        UIManager.widgets[#UIManager.widgets]:calculatePages()
                                        if #UIManager.widgets[#UIManager.widgets].pages[1] == 0 then
                                            Game.state = "action"
                                            UIManager.pop()
                                        end
                                    end
                                })
                            )
                        end
                    end
                })
            )
        end
        return true
    end
    return false
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
    Game.removeCharacter(self)
end
