Gamestate = require("libs/gamestate")
require("src/states/main_menu")

function love.load()
    Gamestate.switch(mainMenuState)
end

function love.update()
    Gamestate.current():update(dt)
end

function love.draw()
    Gamestate.current():draw(dt)
end

function love.resize(w, h)
end
