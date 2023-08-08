Class = require("libs/class")

Tile = Class{}


function Tile:init(id)
    self.name = id
    self.tileDef = db.tiles[id]
    self.visible = false
    self.explored = false
end

function Tile:draw(x, y)
    if self.explored then
        if not self.visible then
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        love.graphics.draw(
            self.tileDef.texture,
            love.graphics.newQuad(self.tileDef.tileX * TILE_W, self.tileDef.tileY * TILE_H,
                TILE_W, TILE_H, self.tileDef.texture),
            (x + TILE_W * BORDER_LEFT) * tileScale,
            (y + TILE_H * BORDER_TOP) * tileScale,
            0,
            tileScale,
            tileScale
        )
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle(
            "fill",
            (x + TILE_W * BORDER_LEFT) * tileScale,
            (y + TILE_H * BORDER_TOP) * tileScale,
            TILE_W - 1,
            TILE_H - 1
        )
        love.graphics.setColor(1, 1, 1)
    end
end

function Tile:canWalk()
    return self.tileDef.canWalk
end

function Tile:canFly()
    return self.tileDef.canFly
end

function Tile:isTransparent()
    return self.tileDef.transparent
end
