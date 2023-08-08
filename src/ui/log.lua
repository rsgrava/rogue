require("src/ui/window")

Log = {
    text = "",
    lines = { "", "", "", "" },
    window = Window({
        x = 0,
        y = GAME_H - TILE_H * 5,
        w = GAME_W / TILE_W,
        h = 5,
    })
}

function Log.log(text)
    if Log.text == "" then
        Log.text = text
    else
        Log.text = Log.text..' '..text
    end
    local _, wrap = love.graphics.getFont():getWrap(Log.text, Log.window.w * TILE_W - TILE_W)
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
            Log.window.y + TILE_H / 2 + fontHeight * (i - 1)
        )
    end
end
