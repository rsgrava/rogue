Class = require("libs/class")
require("src/constants")

InventoryScreen = Class{
    categories = {
        "[A] All Items",
        "[W] Equipment",
        "[E] Edibles",
        "[D] Drinkables",
        "[R] Readables",
        "[Z] Wands",
        "[T] Tools",
        "[M] Misc"
    }
}

function InventoryScreen:init(defs)
    self.onSelect = defs.onSelect
    self.window = Window({
        x = FRAME_SCALE * TILE_W * 2,
        y = TILE_H * FRAME_SCALE * 3,
        w = GAME_W - FRAME_SCALE * TILE_W * (BORDER_RIGHT + BORDER_LEFT + 2),
        h = GAME_H - FRAME_SCALE * TILE_H * (BORDER_BOTTOM + BORDER_TOP + 3)
    })
    self.label = defs.label
    self.labelWindow = Window({
        x = FRAME_SCALE * TILE_W * 2,
        y = TILE_H * FRAME_SCALE * 2,
        w = (love.graphics.getFont():getWidth(self.label) + TILE_W) * FONT_SCALE,
        h = FRAME_SCALE * TILE_H
    })
    self.category = "all items"
    self.page = 1
    self:calculatePages()
    self.firstUpdate = true
end

function InventoryScreen:update(dt)
    if self.firstUpdate then
        self.firstUpdate = false
        return
    end

    if love.keyboard.isPressed("escape") then
        Game.state = "action"
        UIManager.pop()
        return
    end

    if love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        self.page = math.min(self.page + 1, #self.pages)
    elseif love.keyboard.isPressed("left") or love.keyboard.isPressed("kp4") then
        self.page = math.max(self.page - 1, 1)
    elseif love.keyboard.textbuf ~= "" then
        if love.keyboard.textbuf == ("A") then
            self.category = "all items"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("W") then
            self.category = "equipment"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("E") then
            self.category = "edibles"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("D") then
            self.category = "drinkables"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("R") then
            self.category = "readables"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("Z") then
            self.category = "wands"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("T") then
            self.category = "tools"
            self:calculatePages()
        elseif love.keyboard.textbuf == ("M") then
            self.category = "misc"
            self:calculatePages()
        elseif self.onSelect ~= nil then
            local char = string.byte(love.keyboard.textbuf)
            if char >= string.byte("a") and char <= string.byte("v") then
                local slot = self.pages[self.page][char - string.byte("a") + 1]
                if slot ~= nil then
                    self.onSelect(slot)
                end
            end
        end
    end
end

function InventoryScreen:draw()
    self.window:draw()
    self.labelWindow:draw()

    love.graphics.print(
        self.label,
        self.labelWindow.x + TILE_W * FONT_SCALE / 2,
        self.labelWindow.y + TILE_H / 2,
        0,
        FONT_SCALE,
        FONT_SCALE
    )
    
    local slotChar = "a"
    local i = 1
    for slotId, slot in ipairs(self.pages[self.page]) do
        local itemName
        if slot.count == 1 then
            itemName = slot.item.def.singular
        else
            itemName = string.gsub(slot.item.def.plural, "%%d", tostring(slot.count))
        end
        slot.item:draw(self.window.x / FRAME_SCALE + self.window.w / (2 * FRAME_SCALE) * (math.floor(i / 12)),
                  self.window.y / FRAME_SCALE + (((i - 1) % 11) + 0.5) * TILE_H)
        love.graphics.print(
            slotChar..")"..itemName,
            self.window.x + TILE_W * FRAME_SCALE + self.window.w / 2 * (math.floor(i / 12)),
            self.window.y + (((i - 1) % 11) + 0.75) * TILE_H * FRAME_SCALE,
            0,
            FONT_SCALE,
            FONT_SCALE
        )
        slotChar = string.char(string.byte(slotChar) + 1)
        i = i + 1
    end

    love.graphics.setColor(COLORS.LIGHT_GRAY)
    love.graphics.setLineWidth(2)
    -- vertical line
    love.graphics.line(
        self.window.x + self.window.w / 2,
        self.window.y,
        self.window.x + self.window.w / 2,
        self.window.y + self.window.h - 2 * FRAME_SCALE * TILE_H
    )

    --horizontal lines
    love.graphics.line(
        self.window.x,
        self.window.y + self.window.h - 2 * FRAME_SCALE * TILE_H,
        self.window.x + self.window.w ,
        self.window.y + self.window.h - 2 * FRAME_SCALE * TILE_H
    )
    love.graphics.line(
        self.window.x + self.window.w / 2,
        self.window.y,
        self.window.x + self.window.w / 2,
        self.window.y + self.window.h - 2 * FRAME_SCALE * TILE_H
    )
    love.graphics.setLineWidth(1)
    love.graphics.setColor(COLORS.WHITE)

    local leftArrow = "<"
    if self.page == 1 then
        leftArrow = " "
    end
    local rightArrow = ">"
    if self.page == #self.pages then
        rightArrow = " "
    end

    local font = love.graphics.getFont()
    local pageText = "Page "..leftArrow..self.page.."/"..#self.pages..rightArrow
    love.graphics.print(
        pageText,
        self.window.x + self.window.w - (font:getWidth(pageText) + TILE_W) * FONT_SCALE,
        self.window.y + self.window.h - font:getHeight() - FRAME_SCALE * TILE_H,
        0,
        FONT_SCALE,
        FONT_SCALE
    )

    love.graphics.line(
        self.window.x + self.window.w - (font:getWidth(pageText) + 2 * TILE_W) * FONT_SCALE,
        self.window.y + self.window.h - TILE_W * FRAME_SCALE * 2,
        self.window.x + self.window.w - (font:getWidth(pageText) + 2 * TILE_W) * FONT_SCALE,
        self.window.y + self.window.h
    )

    local previousWidth = 0
    local verticalBreak = 0
    for categoryId, category in pairs(self.categories) do
        if categoryId > 1 then
            previousWidth = previousWidth + font:getWidth(self.categories[categoryId - 1]) + TILE_W
            if categoryId == math.floor(#self.categories / 2) + 1 then
                previousWidth = 0
                verticalBreak = 1
            end
        end
        if string.lower(string.sub(category, 5, #category)) == self.category then
            love.graphics.setColor(COLORS.YELLOW)
        end
        love.graphics.print(
            category,
            self.window.x + previousWidth * FONT_SCALE + TILE_W,
            self.window.y + self.window.h + (verticalBreak - 1.75) * TILE_H * FRAME_SCALE,
            0,
            FONT_SCALE,
            FONT_SCALE
        )
        love.graphics.setColor(COLORS.WHITE)
    end
end

function InventoryScreen:calculatePages()
    local slots
    if self.category == "all items" then
        slots = Game.player.inv.slots
    elseif self.category == "equipment" then
        local amulets = Game.player.inv:getCategory("amulets")
        local weapons = Game.player.inv:getCategory("weapons")
        local armor = Game.player.inv:getCategory("armor")
        local rings = Game.player.inv:getCategory("rings")
        slots = table.cat(amulets, weapons)
        slots = table.cat(slots, armor)
        slots = table.cat(slots, rings)
    elseif self.category == "edibles" then
        slots = Game.player.inv:getCategory("edibles")
    elseif self.category == "drinkables" then
        slots = Game.player.inv:getCategory("drinkables")
    elseif self.category == "readables" then
        local books = Game.player.inv:getCategory("books")
        local spellbooks = Game.player.inv:getCategory("spellbooks")
        local scrolls = Game.player.inv:getCategory("scrolls")
        slots = table.cat(books, spellbooks)
        slots = table.cat(slots, scrolls)
    elseif self.category == "wands" then
        slots = Game.player.inv:getCategory("wands")
    elseif self.category == "tools" then
        slots = Game.player.inv:getCategory("tools")
    elseif self.category == "misc" then
        slots = Game.player.inv:getCategory("misc")
    end

    local numPages = math.floor(#slots / 22) + 1
    local numLastItems = #slots % 22
    if numPages > 1 and numLastItems == 0 then
        numPages = numPages - 1
    end

    if self.page > numPages then
        self.page = numPages
    end

    self.pages= {}
    for i = 1, numPages do
        self.pages[i] = {}
        if i == numPages and numPages ~= self.page then
            for j = 1, numLastItems do
                table.insert(self.pages[i], slots[(i - 1) * 22 + j])
            end
        else
            for j = 1, 22 do
                table.insert(self.pages[i], slots[(i - 1) * 22 + j])
            end
        end
    end
end
