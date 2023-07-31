push = require("libs/push")
Gamestate = require("libs/gamestate")
require("src/constants")
require("src/states/main")

function love.load()
    local window_w, window_h = love.window.getDesktopDimensions()
    push:setupScreen(GAME_W, GAME_H, window_w, window_h,
                     {fullscreen = true, resizable = true, vsync = true})

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.keyboard.pressed = {}
    love.keyboard.released = {}

    math.randomseed(os.time())

    Gamestate.switch(mainState)
end

function love.update(dt)
    love.window.setTitle(GAME_TITLE.." - "..love.timer.getFPS().." fps")
    Gamestate.current():update(dt)
    love.keyboard.pressed = {}
    love.keyboard.released = {}
end

function love.draw()
    push:start()
        Gamestate.current():draw(dt)
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.pressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.released[key] = true
end

function love.keyboard.isPressed(key)
    return love.keyboard.pressed[key]
end

function love.keyboard.isReleased(key)
    return love.keyboard.released[key]
end
