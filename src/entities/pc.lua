Class = require("libs/class")
require("src/entities/character")
require("src/entities/pointer")
require("src/ui/inventory_screen")

PC = Class{
    __includes = Character
}

function PC:init(defs)
    Character.init(self, defs)
end

function PC:takeTurn()
    local action = nil
    if love.keyboard.isPressed("kp7") then
        action = self:tryMoveOrAttack(-1, -1)
    elseif love.keyboard.isPressed("kp9") then
        action = self:tryMoveOrAttack(1, -1)
    elseif love.keyboard.isPressed("kp1") then
        action = self:tryMoveOrAttack(-1, 1)
    elseif love.keyboard.isPressed("kp3") then
        action = self:tryMoveOrAttack(1, 1)
    elseif love.keyboard.isPressed("up") or love.keyboard.isPressed("kp8") then
        action = self:tryMoveOrAttack(0, -1)
    elseif love.keyboard.isPressed("down") or love.keyboard.isPressed("kp2") then
        action = self:tryMoveOrAttack(0, 1)
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        action = self:tryMoveOrAttack(-1, 0)
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        action = self:tryMoveOrAttack(1, 0)
    elseif love.keyboard.isPressed("kp5") then
        action = "wait"
    elseif love.keyboard.isPressed("g") then
        action = self:pickUpItem() and "pick_up" or nil
    elseif love.keyboard.isPressed("l") then
        Game.state = "look"
        Game.lookPointer = Pointer(self.tileX, self.tileY)
    elseif love.keyboard.isPressed("i") then
        Game.state = "inventory"
        UIManager.push(InventoryScreen())
    end

    if action ~= nil then
        return db.actions[action]
    else
        return nil
    end
end
