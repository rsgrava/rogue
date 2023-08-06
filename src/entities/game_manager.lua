require("src/algorithms/dungeon_generation/simple")
require("src/entities/character_manager")
require("src/entities/object_manager")

Game = {}

function Game.init()
    local characters, startX, startY
    Game.map, characters, startX, startY = generateSimpleDungeon({
        width = 100,
        height = 100,
        minRooms = 20,
        maxRooms = 30,
        minSize = 6,
        maxSize = 10
    })

    Game.objects = ObjectManager()
    Game.characters = CharacterManager()
    Game.characters:insertList(characters)

    Game.player = PC({
        id = "player",
        tileX = startX,
        tileY = startY
    })
end

function Game.isBlocked(x, y)
    if not Game.map:canWalk(x, y) then
        return true
    end
    return Game.characters:isBlocked(x, y)
end
