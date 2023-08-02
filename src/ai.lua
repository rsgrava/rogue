function attackPlayer(self, map, player, objects)
    if map:isVisible(self.tileX, self.tileY) then
        self:moveTowards(map, objects, player.tileX, player.tileY)
    end
end

function wander(self, map, player, objects)
    if math.random(0, 1) == 1 then
        self:tryMove(map, objects, math.random(-1, 1), math.random(-1, 1))
    end
end
