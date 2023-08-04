Class = require("libs/class")
require("src/utils")
require("src/entities/map")
require("src/entities/npc")

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
    local objects = {}
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
            placeEnemies(map, newRoom, objects)
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

    return map, objects, startX, startY
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

function placeEnemies(map, room, objects)
    for i = 0, 2 do
        local x = math.random(room.x1 + 1, room.x2 - 1)
        local y = math.random(room.y1 + 1, room.y2 - 1)
        if not isBlocked(map, objects, x, y) then
            table.insert(objects, NPC({ id = "rat", tileX = x, tileY = y }))
        end
    end
end

function isBlocked(map, objects, x, y)
    if not map:canWalk(x, y) then
        return true
    end

    for objectId, object in pairs(objects) do
        if object.blocks and object.tileX == x and object.tileY == y  then
            return true
        end
    end

    return false
end

function shapeWalls(map)
    for y = 0, map.height - 1 do
        for x = 0, map.width - 1 do
            if string.startsWith(map:getName(x, y), "wall") then
                -- checking for adjacent walls
                local top_left = not ((x - 1 > 0) and (y - 1 > 0)) or string.startsWith(map:getName(x - 1, y - 1), "wall")
                local top = not (y - 1 > 0) or string.startsWith(map:getName(x, y - 1), "wall")
                local top_right = not((x + 1 < map.width) and (y - 1 > 0)) or string.startsWith(map:getName(x + 1, y - 1), "wall")
                local left = not (x - 1 > 0) or string.startsWith(map:getName(x - 1, y), "wall")
                local right = not (x + 1 < map.width) or string.startsWith(map:getName(x + 1, y), "wall")
                local bottom_left = not ((x - 1 > 0) and (y + 1 < map.height)) or string.startsWith(map:getName(x - 1, y + 1), "wall")
                local bottom = not (y + 1 < map.height) or string.startsWith(map:getName(x, y + 1), "wall")
                local bottom_right = not (x + 1 < map.width) or (y + 1 < map.height) and string.startsWith(map:getName(x + 1, y + 1), "wall")

                -- one way corners
                if top and not bottom and not left and not right then
                    map:setTile("wall_c", x, y)
                elseif bottom and not top and not left and not right then
                    map:setTile("wall_l", x, y)
                elseif not bottom and not top then
                    map:setTile("wall_t", x, y)

                -- outward corners
                elseif right and bottom and not left and not top then
                    map:setTile("wall_tl", x, y)
                elseif left and bottom and not right and not top then
                    map:setTile("wall_tr", x, y)
                elseif top and right and not bottom and not left then
                    map:setTile("wall_bl", x, y)
                elseif top and left and not bottom and not right then
                    map:setTile("wall_br", x, y)

                -- inward corners
                elseif bottom and right and not bottom_right then
                    map:setTile("wall_tl", x, y)
                elseif bottom and left and not bottom_left then
                    map:setTile("wall_tr", x, y)
                elseif top and right and not top_right then
                    map:setTile("wall_bl", x, y)
                elseif top and left and not top_left then
                    map:setTile("wall_br", x, y)

                -- left/right and top/bottom walls
                elseif left and right and (not top or not bottom) then
                    map:setTile("wall_t", x, y)
                elseif top and bottom and (not left or not right) then
                    map:setTile("wall_l", x, y)
                end
            end
        end
    end

    for y = 0, map.height - 1 do
        for x = 0, map.width - 1 do
            if string.startsWith(map:getName(x, y), "wall_") then
                -- checking for adjacent edge walls
                local top_left = (x - 1 > 0) and (y - 1 > 0) and string.startsWith(map:getName(x - 1, y - 1), "wall_")
                local top = (y - 1 > 0) and string.startsWith(map:getName(x, y - 1), "wall_")
                local top_right = (x + 1 < map.width) and (y - 1 > 0) and string.startsWith(map:getName(x + 1, y - 1), "wall_")
                local left = (x - 1 > 0) and string.startsWith(map:getName(x - 1, y), "wall_")
                local right = (x + 1 < map.width) and string.startsWith(map:getName(x + 1, y), "wall_")
                local bottom_left = (x - 1 > 0) and (y + 1 < map.height) and string.startsWith(map:getName(x - 1, y + 1), "wall_")
                local bottom = (y + 1 < map.height) and string.startsWith(map:getName(x, y + 1), "wall_")
                local bottom_right = (x + 1 < map.width) and (y + 1 < map.height) and string.startsWith(map:getName(x + 1, y + 1), "wall_")

                -- three ways
                if not left and top and bottom and right and not bottom_right and not top_right then
                    map:setTile("wall_tw_l", x, y)
                elseif not right and top and bottom and left and not bottom_left and not top_left then
                    map:setTile("wall_tw_r", x, y)
                elseif not top and bottom and left and right and not bottom_left and not bottom_right then
                    map:setTile("wall_tw_t", x, y)
                elseif not bottom and top and left and right and not top_left and not top_right then
                    map:setTile("wall_tw_b", x, y)

                -- four ways
                elseif top and bottom and left and right and
                    not bottom_left and not bottom_right and not top_left and not top_right then
                    map:setTile("wall_fw", x, y)
                end
            end
        end
    end
end
