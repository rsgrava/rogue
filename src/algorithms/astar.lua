require("src/algorithms/bheap")

local function heuristic(node1, node2)
    -- chebyshev
    --return math.max(math.abs(node1.x-node2.x), math.abs(node1.y-node2.y))
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

local function getNeighbors(map, node)
    local neighbors = {}
    for i = 1, #adj do
        local x = node.x + adj[i][1]
        local y = node.y + adj[i][2]
        if map:canWalk(x, y) then
            table.insert(neighbors, { x = x, y = y })
        end
    end
    return neighbors
end

function cantor(node)
    return (node.x + node.y) * (node.x + node.y + 1) / 2 + node.y
end

function astar(map, fromX, fromY, toX, toY)
    if not map:canWalk(toX, toY) then
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

        closed[cantor(current)] = true

        local neighbors = getNeighbors(map, current)
        for _, neighbor in ipairs(neighbors) do
            if not closed[cantor(neighbor)] then
                addedG = current.g + heuristic(current, neighbor)
                if not neighbor.g or gScore < neighbor.g then
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

    return nil
end
