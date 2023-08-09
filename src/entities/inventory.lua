Class = require("libs/class")

Inventory = Class{}

function Inventory:init()
    self.inv = {}
end

function Inventory:insert(item)
    table.insert(self.inv, item)
end

function Inventory:remove(item)
    for itemId, invItem in pairs(self.inv) do
        if item == invItem then
            table.remove(self.inv, itemId)
        end
    end
end

function Inventory:getType(itemType)
    local items = {}
    for itemId, item in pairs(self.inv) do
        if item.type == itemType then
            table.insert(items, item)
        end
    end
    return items
end    

function Inventory:print()
    for itemId, item in pairs(self.inv) do
        print("ID: "..itemId.." Item: "..item.name)
    end
end
