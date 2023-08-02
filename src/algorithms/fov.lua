Class = require("libs/class")
require("src/entities/map")

Slope = Class{}

function Slope:init(y, x)
    self.x = x
    self.y = y
end

function Slope:greater(y, x)
    return self.y * x > self.x * y
end

function Slope:greaterOrEqual(y, x)
    return self.y * x >= self.x * y
end

function Slope:less(y, x)
    return self.y * x < self.x * y
end

function Slope:lessOrEqual(y, x)
    return self.y * x <= self.x * y
end

function euclideanDistance(x, y)
    return math.sqrt(x^2, y^2)
end

function blocksLight(map, x, y, octant, ox, oy)
    if octant == 0 then
        return not map:isTransparent(ox + x, oy - y)
    elseif octant == 1 then
        return not map:isTransparent(ox + y, oy - x)
    elseif octant == 2 then
        return not map:isTransparent(ox - y, oy - x)
    elseif octant == 3 then
        return not map:isTransparent(ox - x, oy - y)
    elseif octant == 4 then
        return not map:isTransparent(ox - x, oy + y)
    elseif octant == 5 then
        return not map:isTransparent(ox - y, oy + x)
    elseif octant == 6 then
        return not map:isTransparent(ox + y, oy + x)
    else
        return not map:isTransparent(ox + x, oy + y)
    end
end

function reveal(map, x, y, octant, ox, oy)
    if octant == 0 then
        map:reveal(ox + x, oy - y)
    elseif octant == 1 then
        map:reveal(ox + y, oy - x)
    elseif octant == 2 then
        map:reveal(ox - y, oy - x)
    elseif octant == 3 then
        map:reveal(ox - x, oy - y)
    elseif octant == 4 then
        map:reveal(ox - x, oy + y)
    elseif octant == 5 then
        map:reveal(ox - y, oy + x)
    elseif octant == 6 then
        map:reveal(ox + y, oy + x)
    else
        map:reveal(ox + x, oy + y)
    end
end

function computeFOV(map, ox, oy, r)
    map:clearVisibility()
    map:reveal(ox, oy)
    for octant = 0, 7 do
        computeIteration(map, ox, oy, r, octant, Slope(1, 1), Slope(0, 1))
    end
end

function computeIteration(map, ox, oy, r, octant, top, bottom)
    for x = 1, r do
        local topY
        if top.x == 1 then
            topY = x
        else
            topY = math.floor(((x * 2 - 1) * top.y + top.x) / (top.x * 2))
            if blocksLight(map, x, topY, octant, ox, oy) then
                if top:greaterOrEqual(topY * 2 + 1, x * 2) and
                    not blocksLight(map, x, topY + 1, octant, ox, oy) then
                    topY = topY + 1
                end
            else
                local ax = x * 2
                if blocksLight(map, x + 1, topY + 1, octant, ox, oy) then
                    ax = ax + 1
                end
                if top:greater(topY * 2 + 1, ax) then
                    topY = topY + 1
                end
            end
        end

        local bottomY
        if bottom.y == 0 then
            bottomY = 0
        else
            bottomY = math.floor(((x * 2 - 1) * bottom.y + bottom.x) / (bottom.x * 2))
            if bottom:greaterOrEqual(bottomY * 2 + 1, x * 2) and
                blocksLight(map, x, bottomY, octant, ox, oy) and
                not blocksLight(map, x, bottomY + 1, octant, ox, oy) then
                bottomY = bottomY + 1
            end
        end

        local wasOpaque = -1
        for y = topY, bottomY, -1 do
            if r < 0 or euclideanDistance(x, y) <= r then
                local isOpaque = blocksLight(map, x, y, octant, ox, oy)
                local isVisible = ((y ~= topY or top:greaterOrEqual(y, x)) and (y ~= bottomY or bottom:lessOrEqual(y, x)))
                if isVisible then
                    reveal(map, x, y, octant, ox, oy)
                end

                if x ~= r then
                    if isOpaque then
                        if wasOpaque == 0 then
                            local nx = x * 2
                            local ny = y * 2 + 1
                            if top:greater(ny, nx) then
                                if y == bottomY then
                                    bottom = Slope(ny, nx)
                                    break
                                else 
                                    computeIteration(map, ox, oy, r, x + 1, top, Slope(ny, nx))
                                end
                            else
                                if y == bottomY then
                                    return
                                end
                            end
                        end
                        wasOpaque = 1
                    else
                        if wasOpaque > 0 then
                            local nx = x * 2
                            local ny = y * 2 + 1
                            if bottom:greaterOrEqual(ny, nx) then
                                return
                            end
                            top = Slope(ny, nx)
                        end
                        wasOpaque = 0
                    end
                end
            end
        end

        if wasOpaque ~= 0 then
            break
        end
    end
end
