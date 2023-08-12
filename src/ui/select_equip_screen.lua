Class = require("libs/class")

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
end

function SelectEquipScreen:update(dt)
    if love.keyboard.isPressed("escape") then
        UIManager.pop()
    elseif love.keyboard.textbuf ~= "" then
        local char = string.byte(love.keyboard.textbuf)
        if char >= string.byte("a") and char <= string.byte("v") then
            local slot = self.items[char - string.byte("a") + 1]
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
    for slotId, slot in pairs(self.items) do
        slot.item:draw(
            self.window.x / FRAME_SCALE + self.window.w / (2 * FRAME_SCALE) * (math.floor(i / 12)),
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
end
