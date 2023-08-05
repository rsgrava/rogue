function attackPlayer(self)
    if self.state == "init" then
        self.state = "wander"
    end

    if Game.map:isVisible(self.tileX, self.tileY) then
        self.state = "attack"
    end

    if self.state == "attack" then
        if self:distanceTo(Game.player.tileX, Game.player.tileY) < 2 then
            self:attack(Game.player)
        else
            self:moveTowards(Game.player.tileX, Game.player.tileY)
        end
    elseif self.state == "wander" then
        wander(self)
    end
end

function wander(self)
    if math.random(0, 1) == 1 then
        self:tryMove(math.random(-1, 1), math.random(-1, 1))
    end
end
