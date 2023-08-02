Class = require("libs/class")
require("src/entities/character")

PlayerCharacter = Class{
    __includes = Character
}

function PlayerCharacter:init(defs)
    Character.init(self, defs)
end

function PlayerCharacter:takeTurn(map, objects)
    if love.keyboard.isPressed("kp7") then
        return self:tryMove(map, objects, -1, -1)
    elseif love.keyboard.isPressed("kp9") then
        return self:tryMove(map, objects, 1, -1)
    elseif love.keyboard.isPressed("kp1") then
        return self:tryMove(map, objects, -1, 1)
    elseif love.keyboard.isPressed("kp3") then
        return self:tryMove(map, objects, 1, 1)
    elseif love.keyboard.isPressed("up") or love.keyboard.isPressed("kp8") then
        return self:tryMove(map, objects, 0, -1)
    elseif love.keyboard.isPressed("down") or love.keyboard.isPressed("kp2") then
        return self:tryMove(map, objects, 0, 1)
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        return self:tryMove(map, objects, -1, 0)
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        return self:tryMove(map, objects, 1, 0)
    end
    return false
end
