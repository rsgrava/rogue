Class = require("libs/class")
require("src/utils")
require("src/algorithms/procgen/common")
require("src/entities/map")
require("src/entities/npc")

function generateSimpleDungeon(defs)
    local map = Map({ width = defs.width, height = defs.height })
    local characters = {}
    local startX, startY = 0

    local rooms = {}
    local numRooms = math.random(defs.minRooms, defs.maxRooms)
    for r = 1, numRooms do
        local w = math.random(defs.minSize, defs.maxSize)
        local h = math.random(defs.minSize, defs.maxSize)
        local x = math.random(0, defs.width - w - 1)
        local y = math.random(0, defs.height - h - 1)
        local newRoom = Room(x, y, w, h)

        local failed = false
        for roomId, room in pairs(rooms) do
            if newRoom:intersects(room) then
                failed = true
                break
            end
        end
        
        if not failed then
            createRoom(map, newRoom)
            placeEnemies(map, newRoom, characters)
            local newX, newY = newRoom:center()
            if #rooms == 0 then
                startX = newX
                startY = newY
            else
                local prevX, prevY = rooms[#rooms]:center()
                if math.random(0, 1) == 1 then
                    createHTunnel(map, prevY, prevX, newX)
                    createVTunnel(map, newX, prevY, newY)
                else
                    createVTunnel(map, prevX, prevY, newY)
                    createHTunnel(map, newY, prevX, newX)
                end
            end
            table.insert(rooms, newRoom)
        end
    end

    shapeWalls(map)

    return map, characters, startX, startY
end
