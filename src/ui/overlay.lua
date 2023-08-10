require("src/constants")
require("src/ui/window")

Overlay = {}

function Overlay:draw()
    -- upper border
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.middle,
        0,
        0,
        0,
        FRAME_SCALE * (GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT),
        FRAME_SCALE
    )

    -- left border
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.middle,
        0,
        TILE_H * FRAME_SCALE,
        0,
        FRAME_SCALE,
        FRAME_SCALE * (GAME_H / (FRAME_SCALE * TILE_H) - BORDER_BOTTOM - BORDER_TOP)
    )

    -- lower border
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.middle,
        0,
        TILE_H * FRAME_SCALE * (GAME_H / (FRAME_SCALE * TILE_H) - BORDER_BOTTOM),
        0,
        FRAME_SCALE * (GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT),
        FRAME_SCALE * 4.5
    )
    
    --right border
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.middle,
        FRAME_SCALE * TILE_W * (GAME_W / (TILE_W * FRAME_SCALE) - BORDER_RIGHT),
        0,
        0,
        8 * FRAME_SCALE,
        FRAME_SCALE * GAME_H / TILE_H
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
