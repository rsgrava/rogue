GlobalAnimation = { timer = 0, frame = 1}

function GlobalAnimation.update(dt)
    GlobalAnimation.timer = GlobalAnimation.timer + dt
    if GlobalAnimation.timer > GLOBAL_ANIMATION_TIMER then
        GlobalAnimation.timer = 0
        if GlobalAnimation.frame == 1 then
            GlobalAnimation.frame = 2
        else
            GlobalAnimation.frame = 1
        end
    end
end
