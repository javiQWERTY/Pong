--[[

 pong-3
    "The Paddle Update"


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

--SPEED at wich we will MOVE our paddle; multiplied by dt in UPDATE
PADDLE_SPEED = 200

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]

function love.load()
  
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  --retro-vision font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)
  
  --larger font for DRAWING the score on the screen
  scoreFont = love.graphics.newFont('font.ttf', 32)
  
  --set active Font to the smallFont object
  love.graphics.setFont(smallFont)
  
      -- initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
  
  --INITIALIZE SCORE VARIABLES, used for RENDERING on the screen an KEEPING TRACK of the winner
  player1Score = 0
  player2Score = 0
  
  --paddle POSITIONS on the Y Axis
  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50
end

--[[
    RUNS every FRAME, with "dt" passed in, our DELTA in seconds
    since the last FRAME, wich LÖVE2D supplies us.
]]
function love.update(dt)
  
  --PLAYER 1 MOVEMENT
  
  --ARRIBA
  if love.keyboard.isDown('w') then
    --add negative paddle speed to current Y scaled by DeltaTime
    player1Y = player1Y + -PADDLE_SPEED * dt
    
    --ABAJO
  elseif love.keyboard.isDown('s') then
    --add positive paddle speed to current Y scaled by Delta time
    player1Y = player1Y + PADDLE_SPEED * dt
  end
  
  --PLAYER 2 MOVEMENT
  
  --ARRIBA
    if love.keyboard.isDown('up') then
    --add negative paddle speed to current Y scaled by DeltaTime
  player2Y = player2Y + -PADDLE_SPEED * dt
  
  --ABAJO
      elseif love.keyboard.isDown('down') then
  --add positive paddle speed to current Y scaled by DeltaTime
  player2Y = player2Y + PADDLE_SPEED * dt
end

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
    
    --DRAW score on the left and right center of the screen
    --need to switch FONT to DRAW before actually printing
    love.graphics.setFont(scoreFont)
    --LEFT score
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    --RIGHT score
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
    
    --now using player's Y variable
    --RENDER first paddle (left side) 
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    
    --RENDER second paddle(right side(the good one))
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
    
    --RENDER the BALL (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) 
    
    -- end rendering at virtual resolution
    push:apply('end')
end
  
  
  
  
  
  
  
  
  