require("src/entities/item")

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

function vline(map, x, y1, y2)
    if y1 > y2 then
        y1, y2 = y2, y1
    end
    for y = y1, y2 do
        map:setTile("grass", x, y)
    end
end

function vlineUp(map, x, y)
    while y >= 0 and map:getName(x, y) == "wall" do
        map:setTile("grass", x, y)
        y = y - 1
    end
end

function vlineDown(map, x, y)
    while y < map.height and map:getName(x, y) == "wall" do
        map:setTile("grass", x, y)
        y = y + 1
    end
end

function hline(map, x1, y, x2)
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    for x = x1, x2 do
        map:setTile("grass", x, y)
    end
end

function hlineLeft(map, x, y)
    while x >= 0 and map:getName(x, y) == "wall" do
        map:setTile("grass", x, y)
        x = x - 1
    end
end

function hlineRight(map, x, y)
    while x < map.width and map:getName(x, y) == "wall" do
        map:setTile("grass", x, y)
        x = x + 1
    end
end

function placeEnemies(map, room, characters)
    for i = 0, math.random(0, 2) do
        local x = math.random(room.x1 + 1, room.x2 - 1)
        local y = math.random(room.y1 + 1, room.y2 - 1)
        if not isBlocked(map, characters, x, y) then
            table.insert(characters, NPC({ id = "rat", tileX = x, tileY = y }))
        end
    end
end

function placeObjects(map, room, objects)
    if math.random(0, 1) == 1 then
        for i = 0, math.random(0, 1) do
            local x = math.random(room.x1 + 1, room.x2 - 1)
            local y = math.random(room.y1 + 1, room.y2 - 1)
            table.insert(objects, { object = Item("dagger"), x = x, y = y })
        end
    end
end

function isBlocked(map, characters, x, y)
    if not map:canWalk(x, y) then
        return true
    end

    for characterId, character in pairs(characters) do
        if character.blocks and character.tileX == x and character.tileY == y  then
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
