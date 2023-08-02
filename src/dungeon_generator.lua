Class = require("libs/class")
require("src/map")
require("src/entities/enemy")

Room = Class{}

function Room:init(x, y, w, h)
    self.x1 = x
    self.x2 = x + w
    self.y1 = y
    self.y2 = y + h
end

function Room:intersects(other)
    return (self.x1 <= other.x2 and self.x2 >= other.x1 and
            self.y1 <= other.y2 and self.y2 >= other.y1)
end

function Room:center()
    return math.floor((self.x1 + self.x2) / 2), math.floor((self.y1 + self.y2) / 2)
end

function generateDungeon(defs)
    local map = Map({ width = defs.width, height = defs.height })
    local enemies = {}
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
            placeEnemies(newRoom, enemies)
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

    return map, enemies, startX, startY
end

function createRoom(map, room)
    for y = room.y1 + 1, room.y2 - 1 do
        for x = room.x1 + 1, room.x2 - 1 do
            map:setTile("grass", x, y)
        end
    end
end

function createHTunnel(map, y, x1, x2)
    for x = math.min(x1, x2), math.max(x1, x2) do
        map:setTile("grass", x, y)
    end
end

function createVTunnel(map, x, y1, y2)
    for y = math.min(y1, y2), math.max(y1, y2) do
        map:setTile("grass", x, y)
    end
end

function placeEnemies(room, enemies)
    for i = 0, 2 do
        local x = math.random(room.x1 + 1, room.x2 - 1)
        local y = math.random(room.y1 + 1, room.y2 - 1)
        table.insert(enemies, Enemy({ id = "rat", tileX = x, tileY = y }))
    end
end
