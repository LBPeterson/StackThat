------------------------
-- Level made by Luke --
------------------------

local Gamestate     = require( LIBRARYPATH.."hump.gamestate"    )
Circles = Gamestate.new()

function Circles:enter(prev)
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  local win = false
  winHeight = 350

  objects = {} -- table to hold all our physical objects
  pickupBlock = 0 -- block that is being held, else set to 0

  --let's create the ground
  ground = {}
  ground.body = love.physics.newBody(world, 700/2, 700-25/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (700/2, 700-50/2)
  ground.shape = love.physics.newRectangleShape(800, 50) --make a rectangle with a width of 700 and a height of 50
  ground.fixture = love.physics.newFixture(ground.body, ground.shape); --attach shape to body
  --table.insert(objects, ground)

  --left "bookend"
  ground2 = {}
  ground2.body = love.physics.newBody(world, 50/2, 700-25-75/2)
  ground2.shape = love.physics.newRectangleShape(50, 75)
  ground2.fixture = love.physics.newFixture(ground2.body, ground2.shape);

  --right "bookend"
  ground3 = {}
  ground3.body = love.physics.newBody(world, 700-50/2, 700-100-75/2)
  ground3.shape = love.physics.newRectangleShape(50, 75)
  ground3.fixture = love.physics.newFixture(ground3.body, ground3.shape);

  ground4 = {}
  ground4.body = love.physics.newBody(world, 700-200/2, 700-25-75/2)
  ground4.shape = love.physics.newRectangleShape(200, 75)
  ground4.fixture = love.physics.newFixture(ground4.body, ground4.shape);

  --let's create a circles
  shape1 = {}
  shape1.body = love.physics.newBody(world, 200, 550, "dynamic")
  shape1.shape = love.physics.newCircleShape(50)
  shape1.fixture = love.physics.newFixture(shape1.body, shape1.shape, 5)
  shape1.fixture:setRestitution(0.1)
  shape1.color = 255,105,97
  table.insert(objects, shape1)

  shape2 = {}
  shape2.body = love.physics.newBody(world, 300, 550, "dynamic")
  shape2.shape = love.physics.newCircleShape(50)
  shape2.fixture = love.physics.newFixture(shape2.body, shape2.shape, 5)
  shape2.fixture:setRestitution(0.1)
  shape2.color = 255,105,97
  table.insert(objects, shape2)

  shape3 = {}
  shape3.body = love.physics.newBody(world, 400, 550, "dynamic")
  shape3.shape = love.physics.newCircleShape(50)
  shape3.fixture = love.physics.newFixture(shape3.body, shape3.shape, 5)
  shape3.fixture:setRestitution(0.1)
  shape3.color = 255,105,97
  table.insert(objects, shape3)

  shape4 = {}
  shape4.body = love.physics.newBody(world, 500, 550, "dynamic")
  shape4.shape = love.physics.newCircleShape(50)
  shape4.fixture = love.physics.newFixture(shape4.body, shape4.shape, 5)
  shape4.fixture:setRestitution(0.1)
  shape4.color = 255,105,97
  table.insert(objects, shape4)

  shape5 = {}
  shape5.body = love.physics.newBody(world, 600, 550, "dynamic")
  shape5.shape = love.physics.newCircleShape(50)
  shape5.fixture = love.physics.newFixture(shape5.body, shape5.shape, 5)
  shape5.fixture:setRestitution(0.1)
  shape5.color = 255,105,97
  table.insert(objects, shape5)

  shape6 = {}
  shape6.body = love.physics.newBody(world, 600, 450, "dynamic")
  shape6.shape = love.physics.newCircleShape(50)
  shape6.fixture = love.physics.newFixture(shape6.body, shape6.shape, 5)
  shape6.fixture:setRestitution(0.1)
  shape6.color = 255,105,97
  table.insert(objects, shape6)

  shape7 = {}
  shape7.body = love.physics.newBody(world, 100, 450, "dynamic")
  shape7.shape = love.physics.newCircleShape(50)
  shape7.fixture = love.physics.newFixture(shape7.body, shape7.shape, 5)
  shape7.fixture:setRestitution(0.1)
  shape7.color = 255,105,97
  table.insert(objects, shape7)

  shape8 = {}
  shape8.body = love.physics.newBody(world, 150, 410, "dynamic")
  shape8.shape = love.physics.newCircleShape(50)
  shape8.fixture = love.physics.newFixture(shape8.body, shape8.shape, 5)
  shape8.fixture:setRestitution(0.1)
  shape8.color = 255,105,97
  table.insert(objects, shape8)

  block1 = {}
  block1.body = love.physics.newBody(world, 0, 550, "dynamic")
  block1.shape = love.physics.newRectangleShape(0, 0, 75, 75)
  block1.fixture = love.physics.newFixture(block1.body, block1.shape, 100)
  block1.fixture:setRestitution(0.1)
  block1.color = 255,105,97
  table.insert(objects, block1)

  block2 = {}
  block2.body = love.physics.newBody(world, 650, 550, "dynamic")
  block2.shape = love.physics.newRectangleShape(0, 0, 75, 75)
  block2.fixture = love.physics.newFixture(block2.body, block2.shape, 100)
  block2.fixture:setRestitution(0.1)
  block2.color = 255,105,97
  table.insert(objects, block2)

  --initial graphics setup
  love.graphics.setBackgroundColor(4, 198, 204) --set the background color to a nice blue
end

function Circles:update(dt)
  world:update(dt) --this puts the world into motion

  -- check if player has won
  if Circles:winCheck() then
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
    Gamestate.switch(Circles)
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
--  if key == 'a' then
--  newBlock = {}
--  newBlock.body = love.physics.newBody(world, 400, 300, "dynamic")
--  newBlock.shape = love.physics.newRectangleShape(0, 0, 100, 50)
--  newBlock.fixture = love.physics.newFixture(newBlock.body, newBlock.shape, 3)
--  newBlock.fixture:setRestitution(0.1)
--  table.insert(objects, newBlock)
--  end
--end

-- check if block is above winHeight and that it isn't moving
function Circles:winCheck()
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

function Circles:draw()
  love.graphics.line(0,winHeight , 700,winHeight) -- Line at height needed to win
  love.graphics.setColor(30, 255, 135) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", ground2.body:getWorldPoints(ground2.shape:getPoints()))
  love.graphics.polygon("fill", ground3.body:getWorldPoints(ground3.shape:getPoints()))
  love.graphics.polygon("fill", ground4.body:getWorldPoints(ground4.shape:getPoints()))

  for i, block in ipairs(objects) do
    if block.isMoving == true then
      love.graphics.setColor(255, 94, 122)
    else
      love.graphics.setColor(45, 117, 120)
    end
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
