Class = require("libs/class")

Tile = Class{}


function Tile:init(id)
    self.tileDef = db.tiles[id]
end

function Tile:draw(x, y)
    love.graphics.draw(
        self.tileDef.texture,
        love.graphics.newQuad(self.tileDef.tileX * TILE_W, self.tileDef.tileY * TILE_H,
            TILE_W, TILE_H, self.tileDef.texture),
        x,
        y
    )
end
