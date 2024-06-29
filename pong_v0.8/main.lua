--[[

    pong-8
    "The Score Update"

]]

--[[

 push is a library that will allow us to draw our game at a virtual
 resolution, instead of however large our window is; used to provide
 a more retro aesthetic

 https://github.com/Ulydev/push
]]
push = require 'push'

--[[
 the "Class" library we're using will allow us to represent anything in
 our game as code, rather than keeping track of many disparate variables and
 methods

 https://github.com/vrld/hump/blob/master/class.lua
]]

Class = require 'class'

--[[
Paddle Class, wich stores POSITIONS and DIMENSIONS for each Paddle
and the LOGIC for RENDERING them
]]
require 'Paddle'

--[[
BALL Class, isn't much different than a Paddle
but wich will MECHANICALLY FUNCTION very different
]]
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    --set the TITLE of our APP WINDOW
    love.window.setTitle('PONG')

    -- "seed" the RNG so that calls to random are always random
    -- use the current time, since that will vary on startup every time
    math.randomseed(os.time())

    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 8)
    
    -- larger font for drawing the score on the screen
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set LÖVE2D's active font to the smallFont object
    love.graphics.setFont(smallFont)

    -- initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
  
      -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    player1Score = 0
    player2Score = 0
  
  --INTIALIZE our player's PADDLES; make them GLOBAL so that they can be
  --by other FUNCTIONS and MODULES
  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  
  --place a BALL in the middle of the screen
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT /2 - 2, 4, 4)
  
    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    gameState = 'start'
  end
  
--[[
    Runs every frame, with "dt" passed in, our delta in seconds 
    since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
  
  if gameState == 'play' then
  
  --COLLISION BLOCK--
  
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position of collision
        if ball:collides(player1) then
          
          ball.dx = -ball.dx * 1.03
          ball.x = player1.x + 5
          
          --keep VELOCITY going in the same direction , but randomize it
          if ball.dy < 0 then            
            ball.dy = -math.random(10, 150)
          else            
            ball.dy = math.random(10, 150)
          end
        end
        
        if ball:collides(player2) then
          
          ball.dx = -ball.dx * 1.03
          ball.x = player2.x - 4
          
          --keep VELOCITY going in the same direction , but randomize it
          if ball.dy < 0 then
            
            ball.dy = -math.random(10, 150)
          else
            
            ball.dy = math.random(10, 150)
          end
        end
        
        -- detect upper boundary collision and reverse if collided
        if ball.y <= 0 then          
          ball.y = 0
          ball.dy = -ball.dy
        end
        
        -- lower screen boundary
        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then          
          ball.y = VIRTUAL_HEIGHT - 4
          ball.dy = -ball.dy
        end
      end
      
    -- if we reach the left or right edge of the screen, 
    -- go back to start and update the score
    if ball.x < 0 then
      
        servingPlayer = 1
        player2Score = player2Score + 1
        ball:reset()
        gameState = 'start'
    end
    
    if ball.x > VIRTUAL_WIDTH then
      
      servingPlayer = 2
      player1Score = player1Score + 1
      ball:reset()
      gameState = 'start'
    end
      
  --END OF COLLISION BLOCK--
  
  -- player 1 movement
  --ARRIBA
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
        --ABAJO
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 movement
    --ARRIBA
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
        --ABAJO
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end
    
    --UPDATE our BALL based on its DX and DY only if we are in the PLAY STATE;
    --scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
      ball:update(dt)
    end
    
    player1:update(dt)
    player2:update(dt)
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
    -- if we press enter during the start state of the game, we'll go into play mode
    -- during play mode, the ball will move in a random direction
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            
            --BALL's new reset method
            ball:reset()
          end
        end
      end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- clear the screen with a specific color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- draw different things based on the state of the game
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end
    
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
    
    --RENDER Paddles, now using their class's RENDER METHOD
    player1:render()
    player2:render()
    
    --RENDER BALL using its class's METHOD
    ball:render()
    
    --new FUNCTION just to demostrate the FPS.
    displayFPS()
    
    -- end rendering at virtual resolution
    push:apply('end')
  end
  
  --[[
    RENDERS the current FPS.
  ]]
  function displayFPS()
    --simple FPS display across all STATES
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 20)
  end