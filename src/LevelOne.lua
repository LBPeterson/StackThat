------------------------
-- Level made by Luke --
------------------------

local Gamestate     = require( LIBRARYPATH.."hump.gamestate"    )
LevelOne = Gamestate.new()

function LevelOne:enter(prev)
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  local win = false
  winHeight = 350

  objects = {} -- table to hold all our physical objects
  pickupBlock = 0 -- block that is being held, else set to 0

  --let's create the ground
  ground = {}
  ground.body = love.physics.newBody(world, 700/2, 700-25/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (700/2, 700-50/2)
  ground.shape = love.physics.newRectangleShape(600, 50) --make a rectangle with a width of 700 and a height of 50
  ground.fixture = love.physics.newFixture(ground.body, ground.shape); --attach shape to body

  --let's create a couple blocks to play around with
  block1 = {}
  block1.body = love.physics.newBody(world, 200, 550, "dynamic")
  block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
  block1.fixture = love.physics.newFixture(block1.body, block1.shape, 5)
  block1.fixture:setRestitution(0.1)
  table.insert(objects, block1)

  block2 = {}
  block2.body = love.physics.newBody(world, 200, 400, "dynamic")
  block2.shape = love.physics.newRectangleShape(0, 0, 100, 50)
  block2.fixture = love.physics.newFixture(block2.body, block2.shape, 3)
  block2.fixture:setRestitution(0.1)
  table.insert(objects, block2)

  block3 = {}
  block3.body = love.physics.newBody(world, 400, 600, "dynamic")
  block3.shape = love.physics.newRectangleShape(0, 0, 100, 50)
  block3.fixture = love.physics.newFixture(block3.body, block3.shape, 8)
  block3.fixture:setRestitution(0.1)
  table.insert(objects, block3)

  block4 = {}
  block4.body = love.physics.newBody(world, 600, 400, "dynamic")
  block4.shape = love.physics.newRectangleShape(0, 0, 100, 50)
  block4.fixture = love.physics.newFixture(block4.body, block4.shape, 3)
  block4.fixture:setRestitution(0.1)
  table.insert(objects, block4)

  cloud1 = {}
  cloud1.x = 30;
  cloud1.y = 30;

  --initial graphics setup
  love.graphics.setBackgroundColor(4, 198, 204) --set the background color to a nice blue
end

function LevelOne:update(dt)
  world:update(dt) --this puts the world into motion

  cloud1.x = cloud1.x + 1
  if (cloud1.x > 800)  then
    cloud1.x = -300;
  end

  -- check if player has won
  if LevelOne:winCheck() then
    win = true
  end

  -- if won game, press enter to go back to menu
  if love.keyboard.isDown("return") then
    win = false
    Gamestate.switch(Menu)
  end
  
  -- press r to restart level
  if love.keyboard.isDown("r") then
    win = false
    Gamestate.switch(LevelOne)
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
function LevelOne:winCheck()
  if love.mouse.isDown("l") == false then
    for i, block in ipairs(objects) do
      if block.isMoving == false then
        x1, y1, x2, y2, x3, y3, x4, y4 = block.body:getWorldPoints(block.shape:getPoints())
        if y1 < winHeight then
          return true
        end
        if y2 < winHeight then
          return true
        end
        if y3 < winHeight then
          return true
        end
        if y4 < winHeight then
          return true
        end
      end
    end
  else
    return false
  end
end

function LevelOne:draw()
  love.graphics.line(0,winHeight , 700,winHeight) -- Line at height needed to win
  love.graphics.setColor(30, 255, 135) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", cloud1.x, cloud1.y, 300, 50);

  love.graphics.setColor(45, 117, 120) -- set the drawing color to grey for the blocks
  for i, block in ipairs(objects) do
    love.graphics.polygon("fill", block.body:getWorldPoints(block.shape:getPoints()))
  end
  love.graphics.setColor(255, 94, 122) -- set the drawing color to red if block is moving moving
  for i, block in ipairs(objects) do
    if block.isMoving == true then
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
