------------------------
-- Level made by Luke --
------------------------

local Gamestate     = require( LIBRARYPATH.."hump.gamestate"    )
Basketball = Gamestate.new()

function Basketball:enter(prev)
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  local win = false
  winHeight = 305

  objects = {} -- table to hold all our physical objects
  pickupBlock = 0 -- block that is being held, else set to 0

  --let's create the ground
  ground = {}
  ground.body = love.physics.newBody(world, 700/2, 700-25/2)
  ground.shape = love.physics.newRectangleShape(800, 50)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape);

  --"hoop"
  ground2 = {}
  ground2.body = love.physics.newBody(world, 5/2+325, 100/2+200)
  ground2.shape = love.physics.newRectangleShape(5, 100)
  ground2.fixture = love.physics.newFixture(ground2.body, ground2.shape);

  ground3 = {}
  ground3.body = love.physics.newBody(world, 100/2+325, 100+5/2+200)
  ground3.shape = love.physics.newRectangleShape(100, 5)
  ground3.fixture = love.physics.newFixture(ground3.body, ground3.shape);

  ground4 = {}
  ground4.body = love.physics.newBody(world, 100-5/2+325, 100/2+200)
  ground4.shape = love.physics.newRectangleShape(5, 100)
  ground4.fixture = love.physics.newFixture(ground4.body, ground4.shape);

  --let's create a Basketball
  shape1 = {}
  shape1.body = love.physics.newBody(world, 200, 550, "dynamic")
  shape1.shape = love.physics.newCircleShape(25)
  shape1.fixture = love.physics.newFixture(shape1.body, shape1.shape, 5)
  shape1.fixture:setRestitution(0.4)
  shape1.color = 255,105,97
  table.insert(objects, shape1)

  block1 = {}
  block1.body = love.physics.newBody(world, 50, 550, "dynamic")
  block1.shape = love.physics.newRectangleShape(0, 0, 75, 75)
  block1.fixture = love.physics.newFixture(block1.body, block1.shape, 100)
  block1.fixture:setRestitution(0.1)
  block1.color = 255,105,97
  table.insert(objects, block1)

  --initial graphics setup
  love.graphics.setBackgroundColor(4, 198, 204) --set the background color to a nice blue
end

function Basketball:update(dt)
  world:update(dt) --this puts the world into motion

  -- check if player has won
  if Basketball:winCheck() then
    win = true
  end

  -- if won game, press enter to go back to menu
  if love.keyboard.isDown("return") then
    love.graphics.setNewFont(20)
    win = false
    Gamestate.switch(Menu)
  end

  -- press r to restart level
  if love.keyboard.isDown("r") then
    win = false
    Gamestate.switch(Basketball)
  end
  
  -- if pickupBlock is assigned a block, move it to the mouse
  if pickupBlock ~= 0 then
    currentX = pickupBlock.body:getX()
    currentY = pickupBlock.body:getY()
    pickupBlock.body:setPosition(love.mouse.getPosition())
    pickupBlock.body:setLinearVelocity( (love.mouse.getX() - currentX)*20, (love.mouse.getY() - currentY)*20 )
  end

  -- checks if blocks are moving
  for i, block in ipairs(objects) do
    x, y = block.body:getLinearVelocity()
    if x == 0 then
      if y == 0 then
        block.isMoving = false;
      end
    else
      block.isMoving = true;
    end
  end

  -- set pickupBlock to block at mouse when clicked
  if love.mouse.isDown("l") then
    for i, block in ipairs(objects) do
      if block.fixture:testPoint(love.mouse.getPosition()) then
            pickupBlock = block
      end
    end
  end

  -- set pickupBlock to 0
  if not love.mouse.isDown("l") then
    if pickupBlock ~= 0 then
      pickupBlock = 0;
    end
  end

  --mouse contraint
  if love.mouse.getY() < winHeight then
    love.mouse.setY(winHeight)
  end

end

-- include if adding blocks is desired in the future
--function love.keypressed(key)
--  if key == 'A' then
--  newBlock = {}
--  newBlock.body = love.physics.newBody(world, 400, 300, "dynamic")
--  newBlock.shape = love.physics.newRectangleShape(0, 0, 100, 50)
--  newBlock.fixture = love.physics.newFixture(newBlock.body, newBlock.shape, 3)
--  newBlock.fixture:setRestitution(0.1)
--  table.insert(objects, newBlock)
--  end
--end

-- check if block is above winHeight and that it isn't moving
function Basketball:winCheck()
  if love.mouse.isDown("l") == false then
    for i, block in ipairs(objects) do
      if block.body:getY() < winHeight then
        if block.isMoving == false then
          return true
        end
      end
    end
  else
    return false
  end
end

function Basketball:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.line(0,winHeight , 700,winHeight) -- Line at height needed to win
  love.graphics.polygon("fill", ground2.body:getWorldPoints(ground2.shape:getPoints()))
  love.graphics.polygon("fill", ground3.body:getWorldPoints(ground3.shape:getPoints()))
  love.graphics.polygon("fill", ground4.body:getWorldPoints(ground4.shape:getPoints()))
  love.graphics.setColor(30, 255, 135) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

  love.graphics.setColor(239, 104, 61)
  for i, block in ipairs(objects) do
    if block.shape:getType() == 'circle' then
      love.graphics.circle("fill", block.body:getX(), block.body:getY(), block.shape:getRadius())
    end
    if block.shape:getType() == 'polygon' then
      love.graphics.polygon("fill", block.body:getWorldPoints(block.shape:getPoints()))
    end
  end

  if win then
    love.graphics.setColor(255, 255, 255)
    font = love.graphics.newFont("HelveticaNeueLTCom-Th.ttf", 72 )
    love.graphics.setFont(font)
    love.graphics.printf("You Win!",  0, 200, 700, 'center')
    font = love.graphics.newFont("HelveticaNeueLTCom-Th.ttf", 48 )
    love.graphics.setFont(font)
    love.graphics.printf("Press enter to\nselect another level",  0, 300, 700, 'center')
  end
  love.graphics.setColor(34, 90, 92)
  font = love.graphics.newFont("HelveticaNeueLTCom-Th.ttf", 18 )
  love.graphics.setFont(font)
  love.graphics.printf("Press R to reset level",  0, 675, 700, 'center')
end
