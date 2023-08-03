function attackPlayer(self)
    if map:isVisible(self.tileX, self.tileY) then
        self:moveTowards(player.tileX, player.tileY)
    end
end

function wander(self)
    if math.random(0, 1) == 1 then
        self:tryMove(math.random(-1, 1), math.random(-1, 1))
    end
end
