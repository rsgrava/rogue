Class = require("libs/class")
require("src/constants")
require("src/ui/input_box")

DebugMenu = Class{}

function DebugMenu:init()
    self.input = InputBox({
        x = 2 * FRAME_SCALE * TILE_W,
        y = GAME_H / 2 - BORDER_BOTTOM * FRAME_SCALE * TILE_H / 2,
        w = (GAME_W / (TILE_W * tileScale) - BORDER_LEFT - BORDER_RIGHT - 2) * FRAME_SCALE * TILE_W,
        label = "Debug",
        onEnter = self.executeCommand
    })
end

function DebugMenu:update(dt)
    self.input:update(dt)
end

function DebugMenu:draw()
    self.input:draw()
end

function DebugMenu:executeCommand(text)
    local args = string.split(text)

    local unknown = true

    if #args >= 3 then
        if args[1] == "spawn" then
            if args[2] == "item" then
                unknown = false
                spawnItem(args)
            elseif args[2] == "npc" then
                unknown = false
                spawnNPC(args)
            end
        end
    end

    if unknown then
        Log.log("Unknown command '"..text.."'")
    end

    Game.state = "action"
    UIManager.pop()
end

function spawnItem(args)
    local itemDef = db.items[args[3]]
    if itemDef then
        local item = Item(args[3])
        if args[4] then
            local itemNum = tonumber(args[4])
            if itemNum then
                for i = 1, itemNum do
                    Game.objects:insert(item, Game.player.tileX, Game.player.tileY)
                end
            else
                Log.log("Invalid number '"..args[4].."'")
            end
        else
            Game.objects:insert(item, Game.player.tileX, Game.player.tileY)
        end
    else
        Log.log("Unknown item '"..args[3].."'")
    end
end

function spawnNPC(args)
    local npcDef = db.characters[args[3]]
    if npcDef then
        local npc = NPC({
            id = args[3],
            tileX = Game.player.tileX,
            tileY = Game.player.tileY
        })
        Game.characters:insert(npc)
    else
        Log.log("Unknown NPC '"..args[3].."'")
    end
end
