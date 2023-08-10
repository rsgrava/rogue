Class = require("libs/class")
require("src/constants")

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
            love.graphics.setColor(COLORS.GRAY)
        end
        love.graphics.draw(
            self.tileDef.texture,
            love.graphics.newQuad(self.tileDef.tileX * TILE_W, self.tileDef.tileY * TILE_H,
                TILE_W, TILE_H, self.tileDef.texture),
            x * tileScale,
            y * tileScale,
            0,
            tileScale,
            tileScale
        )
        love.graphics.setColor(COLORS.WHITE)
    else
        love.graphics.setColor(COLORS.BLACK)
        love.graphics.rectangle(
            "fill",
            x * tileScale,
            y * tileScale,
            TILE_W - 1,
            TILE_H - 1
        )
        love.graphics.setColor(COLORS.WHITE)
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
