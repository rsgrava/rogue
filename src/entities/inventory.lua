Class = require("libs/class")

Inventory = Class{}

function Inventory:init(slots)
    if slots == nil then
        self.slots = {}
    else
        self.slots = slots
    end
end

function Inventory:insert(item, count)
    if item.def.stackable then
        local slotId = self:hasItem(item)
        if slotId == nil then
            table.insert(self.slots, { item = item, count = count })
        else
            self.slots[slotId].count = self.slots[slotId].count + count
        end
    else
        for i = 1, count do
            table.insert(self.slots, { item = item, count = 1 })
        end
    end
end

function Inventory:remove(item, num)
    local slotId = self:hasItem(item)
    if slotId then
        local slot = self.slots[slotId]
        slot.count = slot.count - num
        if slot.count <= 0 then
            table.remove(self.slots, slotId)
        end
    end
end

function Inventory:hasItem(item)
    for slotId, slot in pairs(self.slots) do
        if slot.item.def == item.def then
            return slotId
        end
    end
    return nil
end

function Inventory:getCategory(category)
    local slots = {}
    for slotId, slot in pairs(self.slots) do
        if slot.item.def.category == category then
            table.insert(slots, slot)
        end
    end
    return slots
end    
