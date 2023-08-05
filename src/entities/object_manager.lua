Class = require("libs/class")
require("src/utils")

ObjectManager = Class{}

function ObjectManager:init()
    self.objects = {}
end

function ObjectManager:draw()
    for objectGroupId, objectGroup in pairs(self.objects) do
        for objectId, object in pairs(objectGroup) do
            object:draw()
        end
    end
end

function ObjectManager:insert(item, x, y)
    table.insert(self.objects[cantor(x, y)], item)
end

function ObjectManager:remove(item)
    for objectId, object in pairs(self.objects) do
        if item == object then
            table.remove(self.objects, objectId)
            break
        end
    end
end

function ObjectManager:getAt(x, y)
    return self.objects[cantor(x, y)]
end
