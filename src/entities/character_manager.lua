Class = require("libs/class")
require("src/utils")

CharacterManager = Class{}

function CharacterManager:init()
    self.characters = {}
end

function CharacterManager:draw()
    for characterId, character in pairs(self.characters) do
        character:draw()
    end
end

function CharacterManager:insert(item)
    table.insert(self.characters, item)
    Game.scheduler:insert(item, 0)
end

function CharacterManager:insertList(list)
    for characterId, character in pairs(list) do
        self:insert(character)
    end
end

function CharacterManager:remove(item)
    for characterId, character in pairs(self.characters) do
        if item == character then
            table.remove(self.characters, characterId)
            break
        end
    end
end

function CharacterManager:getAt(x, y)
    for characterId, character in pairs(self.characters) do
        if character.tileX == x and character.tileY == y then
            return character
        end
    end
end

function CharacterManager:isBlocked(x, y)
    for characterId, character in pairs(self.characters) do
        if character.tileX == x and character.tileY == y and character.blocks then
            return character
        end
    end
end
