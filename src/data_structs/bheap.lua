Class = require("libs/class")

BHeap = Class{}

function BHeap:init(cmp)
    self.heap = {}
    self.size = 0
    if cmp == nil then
        self.cmp = function(a, b) return a < b end
    else
        self.cmp = cmp
    end
end

function BHeap:percolateUp(i)
    if i <= 1 then
        return
    end
    
    local pi
    if i % 2 == 0 then
        pi = i / 2
    else
        pi = (i - 1) / 2
    end

    if not self.cmp(self.heap[pi], self.heap[i]) then
        self.heap[pi], self.heap[i] = self.heap[i], self.heap[pi]
        self:percolateUp(pi)
    end
end

function BHeap:percolateDown(i)
    local mini
    local lfi = 2 * i
    local rti = lfi + 1

    if rti > self.size then
        if lfi > self.size then
            return
        else
            mini = lfi
        end
    else
        if self.cmp(self.heap[lfi], self.heap[rti]) then
            mini = lfi
        else
            mini = rti
        end
    end

    if not self.cmp(self.heap[i], self.heap[mini]) then
        self.heap[i], self.heap[mini] = self.heap[mini], self.heap[i]
        self:percolateDown(mini)
    end
end

function BHeap:heapify(item)
    if self.size == 0 then
        return
    end

    if item then
        local i
        for j = 1, #self.heap do
            if self.heap[j] == item then
                i = j
            end
        end
        if i then
            self:percolateDown(i)
            self:percolateUp(i)
        end
        return
    end
    
    for i = math.floor(self.size / 2), 1, -1 do
        self:percolateDown(i)
    end
end

function BHeap:push(item)
    self.size = self.size + 1
    self.heap[self.size] = item
    self:percolateUp(self.size)
end

function BHeap:pop()
    local root
    if self.size > 0 then
        root = self.heap[1]
        self.heap[1] = self.heap[self.size]
        self.heap[self.size] = nil
        self.size = self.size - 1
        if self.size > 1 then
            self:percolateDown(1)
        end
    end
    return root
end

function BHeap:empty()
    return self.size == 0
end

function BHeap:clear()
    self.heap = {}
    self.size = 0
end
