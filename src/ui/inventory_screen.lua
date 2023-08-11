Class = require("libs/class")
require("src/constants")

InventoryScreen = Class{}

function InventoryScreen:init()
    self.window = Window({
        x = FRAME_SCALE * TILE_W * 2,
        y = TILE_H * FRAME_SCALE * 2,
        w = GAME_W - FRAME_SCALE * TILE_W * (BORDER_RIGHT + BORDER_LEFT + 2),
        h = GAME_H - FRAME_SCALE * TILE_H * (BORDER_BOTTOM + BORDER_TOP + 2)
    })
end

function InventoryScreen:update(dt)
end

function InventoryScreen:draw()
    self.window:draw()
    
    local itemChar = "a"
    local i = 1
    for itemId, item in pairs(Game.player.inv.items) do
        love.graphics.print(
            itemChar..")"..item.name,
            self.window.x + TILE_W * FRAME_SCALE,
            self.window.y + i * TILE_H * FRAME_SCALE,
            0,
            FONT_SCALE,
            FONT_SCALE
        )
        itemChar = string.char(string.byte(itemChar) + 1)
        i = i + 1
    end

    love.graphics.setColor(COLORS.LIGHT_GRAY)
    love.graphics.setLineWidth(2)
    -- vertical line
    love.graphics.line(
        self.window.x + self.window.w * TILE_W / 2,
        self.window.y,
        self.window.x + self.window.w * TILE_W / 2,
        self.window.y + (self.window.h - 2 * FRAME_SCALE) * TILE_H
    )
    --horizontal lines
    love.graphics.line(
        self.window.x,
        self.window.y + (self.window.h - 2 * FRAME_SCALE) * TILE_H,
        self.window.x + self.window.w * TILE_W,
        self.window.y + (self.window.h - 2 * FRAME_SCALE) * TILE_H
    )
    love.graphics.line(
        self.window.x + self.window.w * TILE_W / 2,
        self.window.y,
        self.window.x + self.window.w * TILE_W / 2,
        self.window.y + (self.window.h - 2 * FRAME_SCALE) * TILE_H
    )
    love.graphics.setLineWidth(1)
    love.graphics.setColor(COLORS.WHITE)
end
