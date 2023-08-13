Class = require("libs/class")
require("src/constants")

SelectEquipScreen = Class{}

function SelectEquipScreen:init(defs)
    self.character = defs.character
    self.slot = string.sub(string.gsub(defs.slot, "^%s*(.-)%s*$", "%1"), 3, -2)
    self.actualSlot = defs.actualSlot
    local width = FRAME_SCALE * TILE_W * 14
    local height = FRAME_SCALE * TILE_H * 14
    self.window = Window({
        x = GAME_W / 2 - (BORDER_RIGHT - BORDER_LEFT) / 2 * TILE_W * FRAME_SCALE - width / 2,
        y = GAME_H / 2 - (BORDER_BOTTOM - BORDER_TOP) / 2 * TILE_H * FRAME_SCALE - height / 2,
        w = width,
        h = height
    })
    self.labelWindow = Window({
        x = self.window.x,
        y = self.window.y - FRAME_SCALE * TILE_H,
        w = (love.graphics.getFont():getWidth("Select Equipment: "..self.slot) + TILE_W) * FONT_SCALE,
        h = FRAME_SCALE * TILE_H
    })

    self.items = {}

    local inv = self.character.inv
    if defs.actualSlot == "mainhand" then
        self.items = inv:getCategory("weapons")
    elseif defs.actualSlot == "offhand" then
        self.items = inv:getCategory("weapons")
        self.items = table.cat(self.items, inv:getCategory("shields"))
    elseif defs.actualSlot == "amulet" then
        self.items = inv:getCategory("amulets")
    elseif defs.actualSlot == "ring1" or defs.actualSlot == "ring2" then
        self.items = inv:getCategory("rings")
    else
        self.items = inv:getCategory(defs.actualSlot)
    end

    local numPages = math.floor(#self.items / 12) + 1
    local numLastItems = #self.items % 12
    if numPages > 1 and numLastItems == 0 then
        numPages = numPages - 1
    end

    self.page = 1
    self.pages= {}
    for i = 1, numPages do
        self.pages[i] = {}
        if i == numPages and numPages ~= self.page then
            for j = 1, numLastItems do
                table.insert(self.pages[i], self.items[(i - 1) * 12 + j])
            end
        else
            for j = 1, 12 do
                table.insert(self.pages[i], self.items[(i - 1) * 12 + j])
            end
        end
    end
end

function SelectEquipScreen:update(dt)
    if love.keyboard.isPressed("escape") then
        UIManager.pop()
    elseif love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        self.page = math.min(self.page + 1, #self.pages)
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        self.page = math.max(self.page - 1, 1)
    elseif love.keyboard.textbuf ~= "" then
        local char = string.byte(love.keyboard.textbuf)
        if char >= string.byte("a") and char <= string.byte("l") then
            local slot = self.pages[self.page][char - string.byte("a") + 1]
            if slot ~= nil then
                self.character:equip(self.actualSlot, slot.item)
                UIManager:pop()
            end
        end
    end
end

function SelectEquipScreen:draw()
    self.window:draw()
    self.labelWindow:draw()

    love.graphics.print(
        "Select Equipment: "..self.slot,
        self.labelWindow.x + TILE_W * FONT_SCALE / 2,
        self.labelWindow.y + TILE_H / 2,
        0,
        FONT_SCALE,
        FONT_SCALE
    )

    local i = 0
    for slotId, slot in pairs(self.pages[self.page]) do
        slot.item:draw(
            self.window.x / FRAME_SCALE,
            self.window.y / FRAME_SCALE + (i + 0.5) * TILE_H
        )
        local char = string.char(string.byte("a") + i)
        love.graphics.print(
            char..")"..slot.item.def.singular,
            self.window.x + TILE_W * FRAME_SCALE,
            self.window.y + (i + 0.75) * TILE_H * FRAME_SCALE,
            0,
            FONT_SCALE,
            FONT_SCALE
        )
        i = i + 1
    end

    love.graphics.setColor(COLORS.LIGHT_GRAY)
    love.graphics.setLineWidth(2)
    love.graphics.line(
        self.window.x,
        self.window.y + 12.75 * TILE_H * FRAME_SCALE,
        self.window.x + self.window.w,
        self.window.y + 12.75 * TILE_H * FRAME_SCALE
    )
    love.graphics.setLineWidth(1)
    love.graphics.setColor(COLORS.WHITE)

    local pageText = "Page "..self.page.."/"..#self.pages
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(pageText) * FONT_SCALE
    love.graphics.print(
        pageText,
        self.window.x + (self.window.w - textWidth) / 2,
        self.window.y + 12.75 * TILE_H * FRAME_SCALE + font:getHeight() * FONT_SCALE / 2,
        0,
        FONT_SCALE,
        FONT_SCALE
    )
end
