Class = require("libs/class")

Inventory = Class{}

function Inventory:init()
    self.items = {}
end

function Inventory:insert(item)
    table.insert(self.items, item)
end

function Inventory:remove(item)
    for itemId, invItem in pairs(self.items) do
        if item == invItem then
            table.remove(self.items, itemId)
        end
    end
end

function Inventory:getType(itemType)
    local typeItems = {}
    for itemId, item in pairs(self.items) do
        if item.type == itemType then
            table.insert(typeItems, item)
        end
    end
    return typeItems
end    

function Inventory:print()
    for itemId, item in pairs(self.items) do
        print("ID: "..itemId.." Item: "..item.name)
    end
end
