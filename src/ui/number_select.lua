Class = require("libs/class")

NumberSelect = Class{}

function NumberSelect:init(defs)
    self.max = defs.max
    self.item = defs.item
    self.onSelect = defs.onSelect
    self.count = 1
    local width = FRAME_SCALE * TILE_W * 8
    local height = FRAME_SCALE * TILE_H * 5
    self.window = Window({
        x = GAME_W / 2 - (BORDER_RIGHT - BORDER_LEFT) / 2 * TILE_W * FRAME_SCALE - width / 2,
        y = GAME_H / 2 - (BORDER_BOTTOM - BORDER_TOP) / 2 * TILE_H * FRAME_SCALE - height / 2,
        w = width,
        h = height
    })
    self.iconWindow = Window({
        x = self.window.x + width / 2 - FRAME_SCALE * TILE_W * 1.5,
        y = self.window.y - FRAME_SCALE * TILE_H * 3 - TILE_W / 4,
        w = FRAME_SCALE * TILE_W * 3,
        h = FRAME_SCALE * TILE_H * 3
    })
end

function NumberSelect:update(dt)
    if love.keyboard.isPressed("escape") then
        UIManager.pop()
    elseif love.keyboard.isPressed("return") then
        self.onSelect(self.item, self.count)
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        self.count = math.max(self.count - 1, 1)
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        self.count = math.min(self.count + 1, self.max)
    end
end

function NumberSelect:draw()
    self.window:draw()
    self.iconWindow:draw()

    self.item:draw(
        (self.iconWindow.x + 1.5 * TILE_W) / tileScale,
        (self.iconWindow.y + 1.5 * TILE_H) / tileScale,
        2,
        2
    )

    local font = love.graphics.getFont()
    love.graphics.print(
        "How many?",
        self.window.x + self.window.w / 2 - font:getWidth("How many?") * FONT_SCALE / 2,
        self.window.y + TILE_H,
        0,
        FONT_SCALE,
        FONT_SCALE
    )

    love.graphics.print(
        self.count,
        self.window.x + self.window.w / 2 - font:getWidth(self.count) * FONT_SCALE / 2,
        self.window.y + TILE_H * FRAME_SCALE * 2,
        0,
        FONT_SCALE,
        FONT_SCALE
    )

    love.graphics.setColor(COLORS.LIGHT_GRAY)
    love.graphics.line(
        self.window.x + TILE_W * FRAME_SCALE,
        self.window.y + self.window.h - TILE_H * FRAME_SCALE * 1.5,
        self.window.x + self.window.w - TILE_W * FRAME_SCALE,
        self.window.y + self.window.h - TILE_H * FRAME_SCALE * 1.5
    )
    love.graphics.setColor(COLORS.WHITE)

    local barWidth = self.window.w - 2 * TILE_W * FRAME_SCALE
    love.graphics.rectangle(
        "fill",
        self.window.x + TILE_W * FRAME_SCALE * 0.875 + barWidth * (self.count - 1) / (self.max - 1),
        self.window.y + self.window.h - TILE_H * FRAME_SCALE * 2,
        TILE_W * FRAME_SCALE / 4,
        TILE_H * FRAME_SCALE
    )
end
