Class = require("libs/class")

AnimationManager = Class{}

function AnimationManager:init()
    self.timer = 0
    self.frame = 1
end

function AnimationManager:update(dt)
    self.timer = self.timer + dt
    if self.timer > GLOBAL_ANIMATION_TIMER then
        self.timer = 0
        if self.frame == 1 then
            self.frame = 2
        else
            self.frame = 1
        end
    end
end
