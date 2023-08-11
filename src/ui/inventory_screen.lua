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

function InventoryScreen:init()
    self.window = Window({
        x = FRAME_SCALE * TILE_W * 2,
        y = TILE_H * FRAME_SCALE * 2,
        w = GAME_W - FRAME_SCALE * TILE_W * (BORDER_RIGHT + BORDER_LEFT + 2),
        h = GAME_H - FRAME_SCALE * TILE_H * (BORDER_BOTTOM + BORDER_TOP + 2)
    })
    self.category = "all items"
    self:calculatePages()
end

function InventoryScreen:update(dt)
    if love.keyboard.isPressed("escape") then
        Game.state = "action"
        UIManager.pop()
        return
    end

    if love.keyboard.isPressed("right") or love.keyboard.isPressed("kp6") then
        self.page = math.min(self.page + 1, #self.pages)
    elseif love.keyboard.isDown("left") or love.keyboard.isPressed("kp4") then
        self.page = math.max(self.page - 1, 1)
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("a") then
        self.category = "all items"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("w") then
        self.category = "equipment"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("e") then
        self.category = "edibles"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("d") then
        self.category = "drinkables"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("r") then
        self.category = "readables"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("z") then
        self.category = "wands"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("t") then
        self.category = "tools"
        self:calculatePages()
    elseif love.keyboard.isDown("lshift") and love.keyboard.isPressed("m") then
        self.category = "misc"
        self:calculatePages()
    end
end

function InventoryScreen:draw()
    self.window:draw()
    
    local itemChar = "a"
    local i = 1
    for itemId, item in pairs(self.pages[self.page]) do
        item:draw(self.window.x / FRAME_SCALE + self.window.w / (2 * FRAME_SCALE) * (math.floor(i / 13)),
                  self.window.y / FRAME_SCALE + (((i - 1) % 12) + 0.25) * TILE_H)
        love.graphics.print(
            itemChar..")"..item.def.singular,
            self.window.x + TILE_W * FRAME_SCALE + self.window.w / 2 * (math.floor(i / 13)),
            self.window.y + (((i - 1) % 12) + 0.5) * TILE_H * FRAME_SCALE,
            0,
            FONT_SCALE,
            FONT_SCALE
        )
        itemChar = string.char(string.byte(itemChar) + 1)
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
    local items
    if self.category == "all items" then
        items = Game.player.inv.items
    elseif self.category == "equipment" then
        local amulets = Game.player.inv:getCategory("amulets")
        local weapons = Game.player.inv:getCategory("weapons")
        local armor = Game.player.inv:getCategory("armor")
        local rings = Game.player.inv:getCategory("rings")
        items = table.cat(amulets, weapons)
        items = table.cat(items, armor)
        items = table.cat(items, rings)
    elseif self.category == "edibles" then
        items = Game.player.inv:getCategory("edibles")
    elseif self.category == "drinkables" then
        items = Game.player.inv:getCategory("drinkables")
    elseif self.category == "readables" then
        local books = Game.player.inv:getCategory("books")
        local spellbooks = Game.player.inv:getCategory("spellbooks")
        local scrolls = Game.player.inv:getCategory("scrolls")
        items = table.cat(books, spellbooks)
        items = table.cat(items, scrolls)
    elseif self.category == "wands" then
        items = Game.player.inv:getCategory("wands")
    elseif self.category == "tools" then
        items = Game.player.inv:getCategory("tools")
    elseif self.category == "misc" then
        items = Game.player.inv:getCategory("misc")
    end

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

    local numPages = math.floor(#items / 24) + 1
    local numLastItems = #items % 24
    self.page = 1
    self.pages = {}
    for i = 1, numPages do
        self.pages[i] = {}
        if i == numPages then
            for j = 1, numLastItems do
                table.insert(self.pages[i], items[(i - 1) * 24 + j])
            end
        else
            for j = 1, 24 do
                table.insert(self.pages[i], items[(i - 1) * 24 + j])
            end
        end
    end
end
