require("src/algorithms/procgen/simple")
require("src/algorithms/procgen/bsp")
require("src/entities/animation_manager")
require("src/entities/character_manager")
require("src/entities/object_manager")
require("src/entities/scheduler")

Game = {}

function Game.init()
    local characters, objects, startX, startY

    Game.map, characters, objects, startX, startY = generateBSPDungeon({
        mapWidth = 85,
        mapHeight = 40,
        minWidth = 8,
        minHeight = 8,
        depth = 5,
        fullRooms = false
    })

    Game.player = PC({
        id = "player",
        tileX = startX,
        tileY = startY
    })

    Game.scheduler = Scheduler()
    Game.characters = CharacterManager()
    Game.characters:insertList(characters)
    Game.objects = ObjectManager()
    Game.objects:insertList(objects)

    Game.animation = AnimationManager()
end

function Game.removeCharacter(character)
    Game.characters:remove(character)
    Game.scheduler:remove(character)
end

function Game.isBlocked(x, y)
    if not Game.map:canWalk(x, y) then
        return true
    end
    return Game.characters:isBlocked(x, y)
end

function Game.update(dt)
    Game.animation:update(dt)
    Game.scheduler:step()
end

function Game.draw(dt)
    Game.map:draw()
    Game.objects:draw()
    Game.characters:draw()
    Game.player:draw()
end
