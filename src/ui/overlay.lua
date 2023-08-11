require("src/constants")
require("src/ui/window")

Overlay = {}

function Overlay:draw()
    -- upper border
    love.graphics.setColor(COLORS.DARK_PURPLE)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        FRAME_SCALE * TILE_W *(GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT),
        FRAME_SCALE * TILE_H
    )

    -- left border
    love.graphics.rectangle(
        "fill",
        0,
        TILE_H * FRAME_SCALE,
        FRAME_SCALE * TILE_W,
        FRAME_SCALE * TILE_H * (GAME_H / (FRAME_SCALE * TILE_H) - BORDER_BOTTOM - BORDER_TOP)
    )

    -- lower border
    love.graphics.rectangle(
        "fill",
        0,
        TILE_H * FRAME_SCALE * (GAME_H / (FRAME_SCALE * TILE_H) - BORDER_BOTTOM),
        FRAME_SCALE * TILE_W *(GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT),
        FRAME_SCALE * TILE_H * 4.5
    )
    
    --right border
    love.graphics.rectangle(
        "fill",
        FRAME_SCALE * TILE_W * (GAME_W / (TILE_W * FRAME_SCALE) - BORDER_RIGHT),
        0,
        8 * FRAME_SCALE * TILE_W,
        FRAME_SCALE * GAME_H
    )

    --frame
    love.graphics.setColor(COLORS.LIGHT_GRAY)
    love.graphics.setLineWidth(TILE_W / 2)
    love.graphics.rectangle(
        "line",
        FRAME_SCALE * TILE_W * BORDER_LEFT,
        FRAME_SCALE * TILE_H * BORDER_TOP,
        FRAME_SCALE * TILE_W * (GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT - BORDER_LEFT),
        FRAME_SCALE * TILE_H * (GAME_H / (FRAME_SCALE * TILE_H) - BORDER_TOP - BORDER_BOTTOM),
        FRAME_SCALE * TILE_W / 4,
        FRAME_SCALE * TILE_H / 4
    )
    love.graphics.setColor(COLORS.WHITE)
    love.graphics.setLineWidth(1)
end
