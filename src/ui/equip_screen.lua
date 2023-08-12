Class = require("libs/class")
require("src/ui/select_equip_screen")

EquipScreen = Class{
    slots = {
        "a)Main Hand:",
        "b)Offhand:",
        "c)Amulet:",
        "d)Ring 1:",
        "e)Ring 2:",
        "f)Head:",
        "g)Body:",
        "h)Hands:",
        "i)Feet:",
        "j)Ranged:",
        "k)Ammo:"
    },
    actualSlots = {
        "mainhand",
        "offhand",
        "amulet",
        "ring1",
        "ring2",
        "head",
        "body",
        "hands",
        "feet",
        "ranged",
        "ammo"
    }
}

function EquipScreen:init(defs)
    self.character = defs.character
    local width = FRAME_SCALE * TILE_W * 20
    local height = FRAME_SCALE * TILE_H * 12
    self.window = Window({
        x = GAME_W / 2 - (BORDER_RIGHT - BORDER_LEFT) / 2 * TILE_W * FRAME_SCALE - width / 2,
        y = GAME_H / 2 - (BORDER_BOTTOM - BORDER_TOP) / 2 * TILE_H * FRAME_SCALE - height / 2,
        w = width,
        h = height
    })
    self.labelWindow = Window({
        x = self.window.x,
        y = self.window.y - FRAME_SCALE * TILE_H,
        w = (love.graphics.getFont():getWidth("Equip") + TILE_W) * FONT_SCALE,
        h = FRAME_SCALE * TILE_H
    })
end

function EquipScreen:update(dt)
    if love.keyboard.isPressed("escape") then
        Game.state = "action"
        UIManager.pop()
        return
    elseif love.keyboard.textbuf ~= "" then
        local char = string.byte(love.keyboard.textbuf)
        if char >= string.byte("a") and char <= string.byte("k") then
            local slot = self.actualSlots[char - string.byte("a") + 1]
            if self.character.equipment[slot] == nil then
                UIManager.push(
                    SelectEquipScreen({
                        character = self.character,
                        slot = self.slots[char - string.byte("a") + 1],
                        actualSlot = slot 
                    })
                )
            else
                self.character:unequip(slot)
            end
        end
    end
end

function EquipScreen:draw()
    self.window:draw()
    self.labelWindow:draw()

    love.graphics.print(
        "Equip",
        self.labelWindow.x + TILE_W * FONT_SCALE / 2,
        self.labelWindow.y + TILE_H / 2,
        0,
        FONT_SCALE,
        FONT_SCALE
    )

    local i = 0
    for slotId, slot in ipairs(self.slots) do
        local equipName = ""
        local actualSlot = self.actualSlots[slotId]
        local textWidth = love.graphics.getFont():getWidth(slot)
        if self.character.equipment[actualSlot] ~= nil then
            equipName = "  "..self.character.equipment[actualSlot].def.singular
            self.character.equipment[actualSlot]:draw(
                (self.window.x + TILE_W * FRAME_SCALE + textWidth * FONT_SCALE) / tileScale,
                (self.window.y + (i + 0.5) * TILE_H * FRAME_SCALE) / tileScale
            )
        end
        love.graphics.print(
            slot.." "..equipName,
            self.window.x + TILE_W * FRAME_SCALE,
            self.window.y + (i + 0.75) * TILE_H * FRAME_SCALE,
            0,
            FONT_SCALE,
            FONT_SCALE
        )
        i = i + 1
    end
end
