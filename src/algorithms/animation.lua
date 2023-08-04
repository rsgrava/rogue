gAnimation = { timer = 0, frame = 1}

function gAnimation.update(dt)
    gAnimation.timer = gAnimation.timer + dt
    if gAnimation.timer > GLOBAL_ANIMATION_TIMER then
        gAnimation.timer = 0
        if gAnimation.frame == 1 then
            gAnimation.frame = 2
        else
            gAnimation.frame = 1
        end
    end
end
