require("src/tile")

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

function Map:update()
end

function Map:draw()
    for tileId, tile in ipairs(self.tiles) do
        local x = (math.floor((tileId - 1) % self.width)) * TILE_W
        local y = (math.floor((tileId - 1) / self.width)) * TILE_H
        tile:draw(x, y)
    end
end

function Map:setTile(id, x, y)
    self.tiles[x + y * self.width + 1] = Tile(id)
end

function Map:reveal(x, y)
    self.tiles[x + y * self.width + 1].visible = true
    self.tiles[x + y * self.width + 1].explored = true
end

function Map:clearVisibility()
    for tileId, tile in pairs(self.tiles) do
        tile.visible = false
    end
end

function Map:canWalk(x, y)
    return self.tiles[x + self.width * y + 1]:canWalk()
end

function Map:canFly(x, y)
    return self.tiles[x + self.width * y + 1]:canFly()
end

function Map:isTransparent(x, y)
    return self.tiles[x + self.width * y + 1]:isTransparent()
end
