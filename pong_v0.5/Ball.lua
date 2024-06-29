--[[

--BALL CLASS--

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]
Ball = Class{}

function Ball:init(x, y, width, height)
  
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  
  --these variables are for keeping track of our VELOCITY on both the
  --X and Y axis, since the BALL can MOVE in 2D.
  self.dy = math.random(2) == 1 and -100 or 100
  self.dx = math.random(-50, 50)
end

--[[
  Put the BALL in the middle of the screen, with an INITIAL RANDOM VELOCITY
  on both axes.
]]
function Ball:reset()
  
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
  end
  
  --[[
  Simply applies VELOCITY to POSITION, scaled by DeltaTime. 
  ]]
  function Ball:update(dt)
    
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
  end
  
  function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  end