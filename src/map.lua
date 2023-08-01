require("src/tile")

Map = Class{}

function Map:init()
    self.tiles = {}
    self.width = 50
    self.height = 50
    for y = 0, self.height do
        for x = 1, self.width do
            self.tiles[x + y * self.width] = Tile("grass")
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
    return self.tiles[tileX + self.width * tileY].canWalk
end

function Map:canFly(tileX, tileY)
    return self.tiles[tileX + self.width * tileY].canFly
end
