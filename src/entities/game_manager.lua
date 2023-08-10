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
        mapWidth = 40,
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

    Game.camera = Camera()
    Game.state = "action"
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
    if Game.state == "action" then
        Game.animation:update(dt)
        Game.scheduler:step()
        Game.centerCamera(Game.player.tileX, Game.player.tileY)
    elseif Game.state == "look" then
        Game.lookPointer:update()
        Game.centerCamera(Game.lookPointer.tileX, Game.lookPointer.tileY)
        if love.keyboard.isPressed("l") or love.keyboard.isPressed("escape") then
            Game.state = "action"
        end
    elseif Game.state == "inventory" then
        if love.keyboard.isPressed("escape") then
            Game.state = "action"
            UIManager.pop()
        end
    end

    if love.keyboard.isPressed("d") then
        UIManager.clear()
    end
end

function Game.draw(dt)
    Game.camera:attach()
        Game.map:draw()
        Game.objects:draw()
        Game.characters:draw()
        Game.player:draw()
        if Game.state == "look" then
            Game.lookPointer:draw()
        end
    Game.camera:detach()
end

function Game.centerCamera(tileX, tileY)
    local camX = (tileX + 1 / 2) * TILE_W * tileScale - GAME_W / 2 + (BORDER_RIGHT - BORDER_LEFT) * TILE_W * FRAME_SCALE / 2
    local camY = (tileY + 1 / 2) * TILE_H * tileScale - GAME_H / 2 + (BORDER_BOTTOM - BORDER_TOP) * TILE_H * FRAME_SCALE / 2
    local mapWidth = Game.map.width * TILE_W * tileScale + BORDER_RIGHT * TILE_W * FRAME_SCALE 
    local mapHeight = Game.map.height * TILE_H * tileScale + BORDER_BOTTOM * TILE_H * FRAME_SCALE

    if camX < -BORDER_LEFT * TILE_W * FRAME_SCALE then
        camX = -BORDER_LEFT * TILE_W * FRAME_SCALE
    end
    if camX + GAME_W > mapWidth then
        if mapWidth < GAME_W then
            camX = (mapWidth - GAME_W - BORDER_LEFT * TILE_W * FRAME_SCALE) / 2
        else
            camX = mapWidth - GAME_W
        end
    end

    if camY < -BORDER_TOP * TILE_H * FRAME_SCALE then
        camY = -BORDER_TOP * TILE_H * FRAME_SCALE
    end
    if camY + GAME_H > mapHeight then
        if mapHeight < GAME_H then
            camY = (mapHeight - GAME_H - BORDER_TOP * TILE_W * FRAME_SCALE) / 2
        else
            camY = mapHeight - GAME_H
        end
    end

    Game.camera:lookAt(math.floor(camX + love.graphics.getWidth() / 2), math.floor(camY + love.graphics.getHeight() / 2))
end
