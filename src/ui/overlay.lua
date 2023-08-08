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
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.bottom,
        TILE_W * FRAME_SCALE,
        TILE_H * (FRAME_SCALE - 1),
        0,
        FRAME_SCALE * (GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT - BORDER_LEFT),
        1
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
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.right,
        TILE_W * (FRAME_SCALE - 1),
        TILE_H * FRAME_SCALE,
        0,
        1,
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
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.top,
        TILE_W * FRAME_SCALE,
        TILE_H * FRAME_SCALE * (GAME_H / (FRAME_SCALE * TILE_H) - BORDER_BOTTOM),
        0,
        FRAME_SCALE * (GAME_W / (FRAME_SCALE * TILE_W) - BORDER_RIGHT - BORDER_LEFT),
        1
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
    love.graphics.draw(
        assets.graphics.GUI.GUI0,
        WindowQuads.left,
        FRAME_SCALE * TILE_W * (GAME_W / (TILE_W * FRAME_SCALE) - BORDER_RIGHT),
        TILE_H * FRAME_SCALE,
        0,
        1,
        FRAME_SCALE * (GAME_H / (TILE_H * FRAME_SCALE) - BORDER_BOTTOM - BORDER_TOP)
    )
end
