Class = require("libs/class")
require("src/algorithms/deque")
require("src/entities/map")

BSPNode = Class{}

function BSPNode:init(defs)
    self.x = defs.x
    self.y = defs.y
    self.w = defs.w
    self.h = defs.h
    self.level = defs.level
    self.parent = defs.parent
    self.left = defs.left
    self.right = defs.right
    self.horizontal = false
    self.position = 0
end

function BSPNode:isLeaf()
    return self.left == nil and self.right == nil
end

function BSPNode:traverseReverseLevel(callback, args)
    local stack = Deque()
    local queue = Deque()

    queue:pushRight(self)

    while not queue:empty() do
        local node = queue:popLeft()
        stack:pushRight(node)
        if node.left then
            queue:pushRight(node.left)
        end
        if node.right then
            queue:pushRight(node.right)
        end
    end

    while not stack:empty() do
        callback(stack:popRight(), args)
    end
end

function BSPNode:split(horizontal, pos)
    self.horizontal = horizontal
    self.pos = pos
    self.left = BSPNode({
        x = self.x,
        y = self.y,
        w = horizontal and self.w or self.pos - self.x,
        h = horizontal and self.pos - self.y or self.h,
        level = self.level + 1,
        parent = self,
        left = nil,
        right = nil,
    })
    self.right = BSPNode({
        x = horizontal and self.x or self.pos,
        y = horizontal and self.pos or self.y,
        w = horizontal and self.w or self.x + self.w - self.pos,
        h = horizontal and self.y + self.h - self.pos or self.h,
        level = self.level + 1,
        parent = self,
        left = nil,
        right = nil,
    })
end

function BSPNode:splitRecursive(nb, minWidth, minHeight)
    if nb == 0 or (self.w < 2 * minWidth and self.h < 2 * minHeight) then
        self = nil
        return
    end

    local horizontal
    if self.h < 2 * minHeight then
        horizontal = false
    elseif self.w < 2 * minWidth then
        horizontal = true
    else
        horizontal = math.random(0, 1) == 0
    end

    local splitPos
    if horizontal then
        splitPos = math.random(self.y + minHeight, self.y + self.h - minHeight)
    else
        splitPos = math.random(self.x + minWidth, self.x + self.w - minWidth)
    end

    self:split(horizontal, splitPos)
    self.left:splitRecursive(nb - 1, minWidth, minHeight, maxHRatio, maxVRatio) 
    self.right:splitRecursive(nb - 1, minWidth, minHeight, maxHRatio, maxVRatio)
end

function nodeToRoom(node, args)
    local map = args.map
    local minWidth = args.minWidth
    local minHeight = args.minHeight
    local bspRooms = args.bspRooms
    local fullRooms = args.fullRooms

    if node:isLeaf() then
        local minX = node.x + 1
        local maxX = node.x + node.w - 1
        local minY = node.y + 1
        local maxY = node.y + node.h - 1

        if maxX == map.width - 1 then
            maxX = maxX - 1
        end
        if maxY == map.height - 1 then
            maxY = maxY - 1
        end

        if not fullRooms then
            minX = math.random(minX, maxX - minWidth + 1)
            minY = math.random(minY, maxY - minHeight + 1)
            maxX = math.random(minX + minWidth - 2, maxX)
            maxY = math.random(minY + minHeight - 2, maxY)
        end

        node.x = minX
        node.y = minY
        node.w = maxX - minX + 1
        node.h = maxY - minY + 1

        for x = minX, maxX do
            for y = minY, maxY do
                map:setTile("grass", x, y)
            end
        end

        table.insert(bspRooms, Room(node.x, node.y, node.w, node.h))
    else
        local left = node.left
        local right = node.right

        node.x = math.min(left.x, right.x)
        node.y = math.min(left.y, right.y)
        node.w = math.max(left.x + left.w, right.x + right.w) - node.x
        node.h = math.max(left.y + left.h, right.y + right.h) - node.y

        if node.horizontal then
            if left.x + left.w - 1 < right.x or right.x + right.w - 1 < left.x then
                local x1 = math.random(left.x, left.x + left.w - 1)
                local x2 = math.random(right.x, right.x + right.w - 1)
                local y = math.random(left.y + left.h, right.y)
                vlineUp(map, x1, y - 1)
                hline(map, x1, y, x2)
                vlineDown(map, x2, y + 1)
            else
                local minX = math.max(left.x, right.x)
                local maxX = math.min(left.x + left.w - 1, right.x + right.w - 1)
                local x = math.random(minX, maxX)
                while x > map.width - 1 do
                    x = x - 1
                end
                vlineDown(map, x, right.y)
                vlineUp(map, x, right.y - 1)
            end
        else
            if left.y + left.h - 1 < right.y or right.y + right.h - 1 < left.y then
                local y1 = math.random(left.y, left.y + left.h - 1)
                local y2 = math.random(right.y, right.y + right.h - 1)
                local x = math.random(left.x + left.w, right.x)
                hlineLeft(map, x - 1, y1)
                vline(map, x, y1, y2)
                hlineRight(map, x + 1, y2)
            else
                local minY = math.max(left.y, right.y)
                local maxY = math.min(left.y + left.h - 1, right.y + right.h - 1)
                y = math.random(minY, maxY)
                while y > map.height - 1 do
                    y = y - 1
                end
                hlineLeft(map, right.x - 1, y)
                hlineRight(map, right.x, y)
            end
        end
    end
end

function generateBSPDungeon(defs)
    local bsp = BSPNode({
        x = 0,
        y = 0,
        w = defs.mapWidth - 1,
        h = defs.mapHeight - 1,
        level = 0,
        parent = nil,
        left = nil,
        right = nil,
    })
    bsp:splitRecursive(defs.depth, defs.minWidth + 1, defs.minHeight + 1)

    local map = Map({
        width = defs.mapWidth,
        height = defs.mapHeight
    })

    local rooms = {}
    bsp:traverseReverseLevel(
        nodeToRoom,
        {
            map = map,
            bspRooms = rooms,
            minWidth = defs.minWidth,
            minHeight = defs.minHeight,
            maxRooms = defs.maxRooms,
            fullRooms = defs.fullRooms,
        }
    )

    shapeWalls(map)

    local characters = {}
    for roomId, room in pairs(rooms) do
        print(roomId)
        placeEnemies(map, room, characters)
    end

    local startRoom = table.random(rooms)
    local startX, startY = startRoom:center()

    return map, characters, startX, startY
end
