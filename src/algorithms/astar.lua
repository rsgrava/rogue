require("src/algorithms/bheap")
require("src/utils")

local function heuristic(node1, node2)
    return math.sqrt((node1.x-node2.x)^2 + (node1.y-node2.y)^2)
end

local adj = {
    { 0, -1 },
    { 1, 0 },
    { 0, 1 },
    { -1, 0 },
    { 1, -1 },
    { 1, 1 },
    { -1, 1 },
    { -1, -1 },
}

local function getNeighbors(node)
    local neighbors = {}
    for i = 1, #adj do
        local x = node.x + adj[i][1]
        local y = node.y + adj[i][2]
        if not Game.isBlocked(x, y) then
            table.insert(neighbors, { x = x, y = y })
        end
    end
    return neighbors
end

function astar(map, fromX, fromY, toX, toY)
    if Game.isBlocked(toX, toY) then
        return nil
    end

    local start = { x = fromX, y = fromY }
    local finish = { x = toX, y = toY }
    local open = BHeap(function(a, b) return a.f < b.f end)
    local closed = {}

    start.g = 0
    start.h = heuristic(start, finish)
    start.f = start.h
    start.opened = true
    open:push(start)

    while not open:empty() do
        local current = open:pop()
        if not closed[cantor(current.x, current.y)] then
            if current.x == finish.x and current.y == finish.y then
                local path = {}
                while true do
                    if current.prev then
                        table.insert(path, 1, current)
                        current = current.prev
                    else
                        table.insert(path, 1, start)
                        return path
                    end
                end
            end

            closed[cantor(current.x, current.y)] = true

            local neighbors = getNeighbors(current)
            for _, neighbor in ipairs(neighbors) do
                if not closed[cantor(neighbor.x, neighbor.y)] then
                    local addedG = current.g + heuristic(current, neighbor)
                    if not neighbor.g or addedG < neighbor.g then
                        neighbor.g = addedG
                        if not neighbor.h then
                            neighbor.h = heuristic(neighbor, finish)
                        end
                        neighbor.f = addedG + neighbor.h
                        open:push(neighbor)
                        neighbor.prev = current
                    end
                end
            end
        end
    end

    return nil
end
