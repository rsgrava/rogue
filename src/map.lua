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

function Map:setVisible(x, y)
    self.tiles[x + y * self.width + 1].visible = true
end

function Map:setExplored(x, y)
    self.tiles[x + y * self.width + 1].explored = true
end

function Map:computeFOV(playerX, playerY, r)
    for tileId, tile in pairs(self.tiles) do
        tile.visible = false
    end
    for x = math.max(0, playerX - r), math.min(playerX + r, self.width) do
        for y = math.max(0, playerY - r), math.min(playerY + r, self.height) do
            self.tiles[x + self.width * y + 1].wasExplored = true
            self.tiles[x + self.width * y + 1].visible = true
        end
    end
end
