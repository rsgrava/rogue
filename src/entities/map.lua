require("src/entities/tile")

Map = Class{}

function Map:init(defs)
    self.tiles = {}
    self.width = defs.width
    self.height = defs.height
    for y = 0, self.height - 1 do
        for x = 0, self.width do
            self.tiles[x + y * self.width + 1] = Tile("wall")
        end
    end
end

function Map:draw()
    for tileId, tile in ipairs(self.tiles) do
        local x = (math.floor((tileId - 1) % self.width)) * TILE_W
        local y = (math.floor((tileId - 1) / self.width)) * TILE_H
        tile:draw(x, y)
    end
end

function Map:boundCheck(x, y)
    if x < 0 or x >= self.width then
        return false
    elseif y < 0 or y >= self.height then
        return false
    end
    return true
end

function Map:setTile(id, x, y)
    if not self:boundCheck(x, y) then
        return
    end
    self.tiles[x + y * self.width + 1] = Tile(id)
end

function Map:reveal(x, y)
    if not self:boundCheck(x, y) then
        return
    end
    self.tiles[x + y * self.width + 1].visible = true
    self.tiles[x + y * self.width + 1].explored = true
end

function Map:clearVisibility()
    for tileId, tile in pairs(self.tiles) do
        tile.visible = false
    end
end

function Map:exploreAll()
    for tileId, tile in pairs(self.tiles) do
        tile.explored = true
    end
end

function Map:getName(x, y)
    if not self:boundCheck(x, y) then
        return ""
    end
    return self.tiles[x + self.width * y + 1].name
end

function Map:canWalk(x, y)
    if not self:boundCheck(x, y) then
        return false
    end
    return self.tiles[x + self.width * y + 1]:canWalk()
end

function Map:canFly(x, y)
    if not self:boundCheck(x, y) then
        return false
    end
    return self.tiles[x + self.width * y + 1]:canFly()
end

function Map:isTransparent(x, y)
    if not self:boundCheck(x, y) then
        return false
    end
    return self.tiles[x + self.width * y + 1]:isTransparent()
end

function Map:isVisible(x, y)
    if not self:boundCheck(x, y) then
        return false
    end
    return self.tiles[x + self.width * y + 1].visible
end
