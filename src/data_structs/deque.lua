Class = require("libs/class")

Deque = Class{}

function Deque:init()
    self.deque = {}
    self.first = 0
    self.last = -1
end

function Deque:pushLeft(item)
    self.first = self.first - 1
    self.deque[self.first] = item
end

function Deque:pushRight(item)
    self.last = self.last + 1
    self.deque[self.last] = item
end

function Deque:popLeft()
    if self.first > self.last then
        error("list is empty")
    end
    local value = self.deque[self.first]
    self.deque[self.first] = nil
    self.first = self.first + 1
    return value
end

function Deque:popRight()
    if self.first > self.last then error("list is empty") end
    local value = self.deque[self.last]
    self.deque[self.last] = nil
    self.last = self.last - 1
    return value
end

function Deque:empty()
    return self.first == self.last + 1
end
