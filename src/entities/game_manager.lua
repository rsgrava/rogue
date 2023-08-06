require("src/algorithms/dungeon_generation/simple")
require("src/algorithms/dungeon_generation/bsp")
require("src/entities/animation_manager")
require("src/entities/character_manager")
require("src/entities/object_manager")

Game = {}

function Game.init()
    local characters, startX, startY

    Game.map, characters, startX, startY = generateBSPDungeon({
        mapWidth = 85,
        mapHeight = 40,
        minWidth = 8,
        minHeight = 8,
        depth = 5,
        fullRooms = false
    })

    Game.objects = ObjectManager()
    Game.characters = CharacterManager()
    Game.characters:insertList(characters)

    Game.player = PC({
        id = "player",
        tileX = startX,
        tileY = startY
    })

    Game.animation = AnimationManager()
end

function Game.isBlocked(x, y)
    if not Game.map:canWalk(x, y) then
        return true
    end
    return Game.characters:isBlocked(x, y)
end

function Game.update(dt)
    Game.animation:update(dt)
end