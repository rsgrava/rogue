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

function Map:canWalk(tileX, tileY)
    return self.tiles[tileX + self.width * tileY + 1]:canWalk()
end

function Map:canFly(tileX, tileY)
    return self.tiles[tileX + self.width * tileY + 1]:canFly()
end
