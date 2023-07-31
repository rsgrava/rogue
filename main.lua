push = require("libs/push")
Gamestate = require("libs/gamestate")
require("src/constants")
require("src/states/main_menu")

function love.load()
    local window_w, window_h = love.window.getDesktopDimensions()
    push:setupScreen(GAME_W, GAME_H, window_w, window_h,
                     {fullscreen = true, resizable = true, vsync = true})
    Gamestate.switch(mainMenuState)
end

function love.update()
    Gamestate.current():update(dt)
end

function love.draw()
    push:start()
        Gamestate.current():draw(dt)
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end
