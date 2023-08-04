function attackPlayer(self)
    if self.state == "init" then
        self.state = "wander"
    end

    if gMap:isVisible(self.tileX, self.tileY) then
        self.state = "attack"
    end

    if self.state == "attack" then
        if self:distanceTo(gPlayer.tileX, gPlayer.tileY) < 2 then
            self:attack(gPlayer)
        else
            self:moveTowards(gPlayer.tileX, gPlayer.tileY)
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
