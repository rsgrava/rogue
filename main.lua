setmetatable(_G, {
  __index = require("libs/cargo").init('/')
})
push = require("libs/push")
Gamestate = require("libs/gamestate")
require("libs/slam")

require("src/constants")
require("src/states/main")
require("src/ui/ui_manager")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    local window_w, window_h = love.window.getDesktopDimensions()
    push:setupScreen(GAME_W, GAME_H, window_w, window_h,
                     {fullscreen = true, resizable = true, vsync = true})

    love.graphics.setFont(assets.fonts.VGA_437(16))

    love.keyboard.pressed = {}
    love.keyboard.released = {}
    love.keyboard.textbuf = ""
    love.mouse.wheel = ""

    tileScale = TILE_SCALE

    math.randomseed(os.time())

    Gamestate.switch(mainState)
end

function love.update(dt)
    love.window.setTitle(GAME_TITLE.." - "..love.timer.getFPS().." fps")
    Gamestate.current():update(dt)
    UIManager.update(dt)
    love.keyboard.pressed = {}
    love.keyboard.released = {}
    love.keyboard.textbuf = ""
    love.mouse.wheel = ""
end

function love.draw()
    push:start()
        Gamestate.current():draw(dt)
        UIManager.draw()
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

function love.textinput(text)
    love.keyboard.textbuf = text
end

function love.wheelmoved(x, y)
    if y > 0 then
        love.mouse.wheel = "up"
    elseif y < 0 then
        love.mouse.wheel = "down"
    end
end

function love.keyboard.isPressed(key)
    return love.keyboard.pressed[key]
end

function love.keyboard.isReleased(key)
    return love.keyboard.released[key]
end

function love.mouse.wheelMoved()
    return love.mouse.wheel
end
