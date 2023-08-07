Class = require("libs/class")

Scheduler = Class{}

function Scheduler:init()
    local player = { actor = Game.player, energy = 0 }
    self.schedule = { player }
    self.shouldSort = true
    self.actedThisFrame = false
end

function Scheduler:insert(actor, energy)
    table.insert(self.schedule, { actor = actor, energy = energy })
    self.shouldSort = true
end

function Scheduler:remove(item)
    for actorId, actor in pairs(self.schedule) do
        if actor.actor == item then
            table.remove(self.schedule, actorId)
            self.shouldSort = true
            break
        end
    end
end

function Scheduler:sort()
    table.sort(self.schedule, function(a, b) return a.energy > b.energy end)
end

function Scheduler:step()
    local energySpent = 0
    while energySpent ~= nil do
        if self.shouldSort then
            self:sort()
        end
        
        while self.schedule[1].energy < 100 do
            for actorId, actor in pairs(self.schedule) do
                actor.energy = actor.energy + actor.actor.speed
            end
            self:sort()
        end
        
        self.shouldSort = false

        local currActor = self.schedule[1]
        if currActor.actor == Game.player and self.actedThisFrame then
            self.actedThisFrame = false
            break
        end
        energySpent = currActor.actor:takeTurn()
        if energySpent ~= nil then
            currActor.energy = currActor.energy - energySpent
            self.shouldSort = true
            if currActor.actor == Game.player then
                self.actedThisFrame = true
            end
        end
    end
end

function Scheduler:print()
    for actorId, actor in pairs(self.schedule) do
        print("ID: "..actorId.." Actor: "..actor.actor.name.. " Energy: "..actor.energy)
    end
end
