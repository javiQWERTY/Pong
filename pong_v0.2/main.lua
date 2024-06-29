--[[

 pong-2
    "The Rectangle Update"


-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
]]
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]

function love.load()
  
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  --retro-vision font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)
  
  --set active Font to the smallFont object
  love.graphics.setFont(smallFont)
  
      -- initialize window with virtual resolution
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
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    end
end

function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')
    
    --CLEAR THE SCREEN with a specific color; in this case,
    --a color similar to some versions the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    --DRAW welcome text toward the top of the screen
    love.graphics.printf('Hello Pong', 0, 20, VIRTUAL_WIDTH, 'center')
    
    --PADDLES are simply rectangles we DRAW on the screen at certain points,
    --as is the ball.
    
    --RENDER first paddle (left side)
    love.graphics.rectangle('fill', 10, 30, 5, 20)
    
    --RENDER second paddle(right side(the good one))
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)
    
    --RENDER the BALL (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) 
    
    -- end rendering at virtual resolution
    push:apply('end')
end
  
  
  
  
  
  
  
  
  