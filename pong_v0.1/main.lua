--[[

Pong 1

The Low - Res Update
Texture Filtering


-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push

]]

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[
Push convierte la textura de 1280 x 720 
a una textura virtual de 432 x 243 
para simular unos graficos pixelados.
]]

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
--[[
  use nearest-neighbor filtering on upscaling and downscaling 
  to prevent blurring of text and graphics.
]]
    love.graphics.setDefaultFilter('nearest', 'nearest')
--[[
  initialize our virtual resolution, 
  which will be rendered within our actual window no matter its dimensions; 
  replaces our love.window.setMode call from the last example.
]]
push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]

function love.keypressed(key)
  
  if key == 'escape' then
    --function LÖVE2D give us to terminate application
    love.event.quit()
  end
end


--[[
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]

function love.draw()
  
  -- begin rendering at virtual resolution
  push:apply('start')
  
  -- condensed onto one line from last example
  -- note we are now using virtual width and height now for text placement
  
  love.graphics.printf(
    'HELLO PONG',
    0,
    VIRTUAL_HEIGHT / 2 - 6,
    VIRTUAL_WIDTH, 
    'center')
  
  --end rendering at virtual resolution
  push:apply('end')
  
  end







