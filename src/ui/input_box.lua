Class = require("libs/class")

InputBox = Class{}

function InputBox:init(defs)
    self.window = Window({
        x = defs.x,
        y = defs.y,
        w = defs.w,
        h = 4 * TILE_H,
        frameWidth = defs.frameWidth,
        frameColor = defs.frameColor,
        rounded = defs.rounded,
    })
    if defs.label ~= nil then
        self.label = defs.label
        self.labelWindow = Window({
            x = defs.x,
            y = defs.y - 4 * TILE_H,
            w = (love.graphics.getFont():getWidth(defs.label) + TILE_W) * FRAME_SCALE,
            h = 4 * TILE_H,
        })
    end
    self.onEnter = defs.onEnter
    self.maxChars = math.floor(defs.w / (love.graphics.getFont():getWidth("a") * FRAME_SCALE)) - 1
    self.buf = ""
    self.eraseTimer = 0
    self.blinkTimer = 0
    self.showLine = true
    self.firstUpdate = true
end

function InputBox:update(dt)
    if love.keyboard.isPressed("return") then
        self:onEnter(self.buf)
        self.buf = ""
        return
    end

    if self.firstUpdate then
        self.firstUpdate = false
    else
        if self.maxChars then
            if #self.buf < self.maxChars then
                self.buf = self.buf..love.keyboard.textbuf
            end
        end
        if love.keyboard.isDown("backspace") then
            if love.keyboard.isPressed("backspace") then
                self.buf = string.sub(self.buf, 1, -2)
            end
            self.eraseTimer = self.eraseTimer + dt
            if self.eraseTimer > 0.1 then
                self.eraseTimer = 0
                self.buf = string.sub(self.buf, 1, -2)
            end
        else
            self.eraseTimer = 0
        end
    end

    self.blinkTimer = self.blinkTimer + dt
    if self.blinkTimer > 0.3 then
        self.blinkTimer = 0
        self.showLine = not self.showLine
    end
end

function InputBox:draw()
    self.window:draw()
    love.graphics.print(
        self.buf,
        self.window.x + TILE_W * FRAME_SCALE / 2,
        self.window.y + TILE_H / 2,
        0,
        FRAME_SCALE,
        FRAME_SCALE
    )

    if self.labelWindow then
        self.labelWindow:draw()
        love.graphics.print(
            self.label,
            self.labelWindow.x + TILE_W * FRAME_SCALE / 2,
            self.labelWindow.y + TILE_H / 2,
            0,
            FRAME_SCALE,
            FRAME_SCALE
        )
    end

    if self.showLine then
        love.graphics.setLineWidth(2)
        love.graphics.line(
            self.window.x + love.graphics.getFont():getWidth(self.buf) * FRAME_SCALE + 3 * TILE_W / 2,
            self.window.y + TILE_H / 2,
            self.window.x + love.graphics.getFont():getWidth(self.buf) * FRAME_SCALE + 3 * TILE_W / 2,
            self.window.y + TILE_H * FRAME_SCALE + TILE_H / 2
        )
        love.graphics.setLineWidth(1)
    end
end
