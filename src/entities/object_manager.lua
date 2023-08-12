Class = require("libs/class")
require("src/utils")
require("src/entities/sprite")

ObjectManager = Class{}

function ObjectManager:init()
    self.objects = {}
    self.bagSprite = Sprite({
        texture1 = assets.graphics.Items.Chest0,
        quadX = 0,
        quadY = 2,
    })
end

function ObjectManager:draw()
    for objectGroupId, objectGroup in pairs(self.objects) do
        local x, y = inverseCantor(objectGroupId)
        if Game.map:isVisible(x, y) then
            if #objectGroup == 1 then
                objectGroup[1].item:draw(x * TILE_W, y * TILE_H)
            else
                self.bagSprite:draw(x * TILE_W, y * TILE_H)
            end
        end
    end
end

function ObjectManager:insert(item, count, x, y)
    local hash = cantor(x, y)
    local objList = self.objects[hash]

    if objList == nil then
        objList = {}
        self.objects[hash] = objList
    end

    if item.def.stackable then
        for objectId, object in pairs(objList) do
            if object.item.def == item.def then
                object.count = object.count + count
                return
            end
        end
        table.insert(objList, { item = item, count = count })
        return
    end

    for i = 1, count do
        table.insert(objList, { item = item, count = 1 })
    end
end

function ObjectManager:insertList(list)
    for objectId, object in pairs(list) do
        self:insert(object.object, 1, object.x, object.y)
    end
end

function ObjectManager:remove(item, count, x, y)
    for objectGroupId, objectGroup in pairs(self.objects) do
        for objectId, object in pairs(objectGroup) do
            if item == object.item then
                object.count = object.count - count
                if object.count <= 0 then
                    table.remove(objectGroup, objectId)
                end
                if #objectGroup == 0 then
                    self.objects[objectGroupId] = nil
                end
                break
            end
        end
    end
end

function ObjectManager:getAt(x, y)
    return self.objects[cantor(x, y)]
end
