require("src/ui/window")

Log = {
    text = "",
    lines = { "", "", "", "", "" },
    window = Window({
        x = FRAME_SCALE * TILE_W,
        y = GAME_H - TILE_H * 12.5,
            w = GAME_W / TILE_W - FRAME_SCALE * 9,
        h = 12,
    })
}

function Log.log(text)
    if Log.text == "" then
        Log.text = text
    else
        Log.text = Log.text..' '..text
    end
    local _, wrap = love.graphics.getFont():getWrap(Log.text, ((Log.window.w - 1) * TILE_W) / FONT_SCALE)
    for i = 1, #Log.lines do
        local line = ""
        if #wrap <= #Log.lines then
            line = wrap[i] or ""
        else
            line = wrap[#wrap-#Log.lines+i]
        end
        Log.lines[i] = line
    end
end

function Log.draw()
    width, height = love.graphics.getDimensions()
    Log.window:draw()
    local fontHeight = love.graphics.getFont():getHeight()
    for i = 1, #Log.lines do
        love.graphics.print(
            Log.lines[i],
            Log.window.x + TILE_W / 2,
            Log.window.y + fontHeight + fontHeight * (i - 1) * FONT_SCALE,
            0,
            FONT_SCALE
        )
    end
end
