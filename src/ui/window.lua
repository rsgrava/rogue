Class = require("libs/class")
require("src/constants")

Window = Class{}

function Window:init(defs)
    self.x = defs.x
    self.y = defs.y
    self.w = defs.w
    self.h = defs.h
    
    if defs.frameWidth then
        self.frameWidth = defs.frameWidth
    else
        self.frameWidth = 4
    end

    if defs.mainColor then
        self.mainColor = defs.mainColor
    else
        self.mainColor = COLORS.DARK_PURPLE
    end

    if defs.frameColor then
        self.frameColor = defs.frameColor
    else
        self.frameColor = COLORS.LIGHT_GRAY
    end

    if defs.rounded then
        self.rounded = defs.rounded
    else
        self.rounded = true
    end
end

function Window:draw()
    -- main window
    love.graphics.setColor(self.mainColor)
    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.w,
        self.h
    )

    -- frame
    love.graphics.setColor(self.frameColor)
    love.graphics.setLineWidth(self.frameWidth)
    love.graphics.rectangle(
        "line",
        self.x,
        self.y,
        self.w,
        self.h,
        self.rounded and TILE_W / 4 or 0,
        self.rounded and TILE_H / 4 or 0
    )
    love.graphics.setColor(COLORS.WHITE)
    love.graphics.setLineWidth(1)
end
