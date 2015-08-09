-------------------------
-- Menu made by Nicole --
-------------------------

local Gamestate     = require( LIBRARYPATH.."hump.gamestate"    )
Menu = Gamestate.new()

function Menu:enter(prev)
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  menuObjects = {} -- table to hold all our physical objects
  bounds = {} -- table to hold window and selection box boundary objects
  pickupBlock = 0 -- block that is being held, else set to 0

  --window boundaries
  ground1 = {}
  ground1.body = love.physics.newBody(world, 700/2, 750, "static")
  ground1.shape = love.physics.newRectangleShape(800, 100)
  ground1.fixture = love.physics.newFixture(ground1.body, ground1.shape);
  table.insert(bounds, ground1)

  ground2 = {}
  ground2.body = love.physics.newBody(world, 700/2, -50, "static")
  ground2.shape = love.physics.newRectangleShape(800, 100)
  ground2.fixture = love.physics.newFixture(ground2.body, ground2.shape);
  table.insert(bounds, ground2)

  ground3 = {}
  ground3.body = love.physics.newBody(world, -50, 700/2, "static")
  ground3.shape = love.physics.newRectangleShape(100, 800)
  ground3.fixture = love.physics.newFixture(ground3.body, ground3.shape);
  table.insert(bounds, ground3)
  
  ground4 = {}
  ground4.body = love.physics.newBody(world, 750, 700/2, "static")
  ground4.shape = love.physics.newRectangleShape(100, 800)
  ground4.fixture = love.physics.newFixture(ground4.body, ground4.shape);
  table.insert(bounds, ground4)
  
  --selection box
  selection1 = {}
  selection1.body = love.physics.newBody(world, 700/2+60, 700/2, "static")
  selection1.shape = love.physics.newRectangleShape(5, 125)
  selection1.fixture = love.physics.newFixture(selection1.body, selection1.shape);
  table.insert(bounds, selection1)

  selection2 = {}
  selection2.body = love.physics.newBody(world, 700/2-60, 700/2, "static")
  selection2.shape = love.physics.newRectangleShape(5, 125)
  selection2.fixture = love.physics.newFixture(selection2.body, selection2.shape);
  table.insert(bounds, selection2)
  
  selection3 = {}
  selection3.body = love.physics.newBody(world, 700/2, 700/2+60, "static")
  selection3.shape = love.physics.newRectangleShape(125, 5)
  selection3.fixture = love.physics.newFixture(selection3.body, selection3.shape);
  table.insert(bounds, selection3)
  
  selection4 = {}
  selection4.body = love.physics.newBody(world, 700/2, 700/2-60, "static")
  selection4.shape = love.physics.newRectangleShape(125, 5)
  selection4.fixture = love.physics.newFixture(selection4.body, selection4.shape);
  table.insert(bounds, selection4)
  
  --level circles
  shape1 = {}
  shape1.body = love.physics.newBody(world, 100, 120, "dynamic")
  shape1.shape = love.physics.newCircleShape(50)
  shape1.fixture = love.physics.newFixture(shape1.body, shape1.shape, 5)
  shape1.fixture:setRestitution(0.4)
  shape1.color = {153, 72, 131}
  shape1.number = "1"
  table.insert(menuObjects, shape1)
  
  shape2 = {}
  shape2.body = love.physics.newBody(world, 200, 120, "dynamic")
  shape2.shape = love.physics.newCircleShape(50)
  shape2.fixture = love.physics.newFixture(shape2.body, shape2.shape, 5)
  shape2.fixture:setRestitution(0.4)
  shape2.color = {204, 71, 118}
  shape2.number = "2"
  table.insert(menuObjects, shape2)

  shape3 = {}
  shape3.body = love.physics.newBody(world, 300, 120, "dynamic")
  shape3.shape = love.physics.newCircleShape(50)
  shape3.fixture = love.physics.newFixture(shape3.body, shape3.shape, 5)
  shape3.fixture:setRestitution(0.4)
  shape3.color = {255, 94, 122}
  shape3.number = "3"
  table.insert(menuObjects, shape3)
  
  shape4 = {}
  shape4.body = love.physics.newBody(world, 400, 120, "dynamic")
  shape4.shape = love.physics.newCircleShape(50)
  shape4.fixture = love.physics.newFixture(shape4.body, shape4.shape, 5)
  shape4.fixture:setRestitution(0.4)
  shape4.color = {30, 255, 135}
  shape4.number = "4"
  table.insert(menuObjects, shape4)

  shape5 = {}
  shape5.body = love.physics.newBody(world, 500, 120, "dynamic")
  shape5.shape = love.physics.newCircleShape(50)
  shape5.fixture = love.physics.newFixture(shape5.body, shape5.shape, 5)
  shape5.fixture:setRestitution(0.4)
  shape5.color = {45, 117, 120}
  shape5.number = "5"
  table.insert(menuObjects, shape5)
  
  shape6 = {}
  shape6.body = love.physics.newBody(world, 600, 120, "dynamic")
  shape6.shape = love.physics.newCircleShape(50)
  shape6.fixture = love.physics.newFixture(shape6.body, shape6.shape, 5)
  shape6.fixture:setRestitution(0.4)
  shape6.color = {34, 90, 92}
  shape6.number = "6"
  table.insert(menuObjects, shape6)
  
  love.graphics.setBackgroundColor(4, 198, 204)
end

function Menu:update(dt)
  world:update(dt) --this puts the world into motion
  
  if love.mouse.isDown("l") == false then
    for i, block in ipairs(menuObjects) do
      if block.body:getY() > 700/2-60 and block.body:getY() < 700/2+60 and block.body:getX() > 700/2-60 and block.body:getX() < 700/2+60 then
        if block.isMoving == false then
          if block.number == "1" then
            Gamestate.switch(LevelOne)
          end
          if block.number == "2" then
            Gamestate.switch(LevelTwo)
          end
          if block.number == "3" then
            Gamestate.switch(LevelThree)
          end
          if block.number == "4" then
            Gamestate.switch(LevelFour)
          end
          if block.number == "5" then
            Gamestate.switch(Circles)
          end
          if block.number == "6" then
            Gamestate.switch(Basketball)
          end
        end
      end
    end
  end

  -- if won game, press enter to go back to menu
  if love.keyboard.isDown("return") then
    Gamestate.switch(Menu)
  end

  -- if pickupBlock is assigned a block, move it to the mouse
  if pickupBlock ~= 0 then
    currentX = pickupBlock.body:getX()
    currentY = pickupBlock.body:getY()
    pickupBlock.body:setPosition(love.mouse.getPosition())
    pickupBlock.body:setLinearVelocity( (love.mouse.getX() - currentX)*20, (love.mouse.getY() - currentY)*20 )
  end

  -- checks if blocks are moving
  for i, block in ipairs(menuObjects) do
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
    for i, block in ipairs(menuObjects) do
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

function Menu:draw()
  love.graphics.setColor(255, 255, 255)
  font = love.graphics.newFont("HelveticaNeueLTCom-Th.ttf", 48 )
  love.graphics.setFont(font)
  for i, block in ipairs(bounds) do
    love.graphics.polygon("fill", block.body:getWorldPoints(block.shape:getPoints()))
  end
  for i, block in ipairs(menuObjects) do
    if block.shape:getType() == 'circle' then
      love.graphics.setColor(block.color)
      love.graphics.circle("fill", block.body:getX(), block.body:getY(), block.shape:getRadius())
      love.graphics.setColor(255, 255, 255)
      love.graphics.print(block.number, block.body:getX()-13, block.body:getY()-30)
    end
  end
  font = love.graphics.newFont("HelveticaNeueLTCom-UltLt.ttf", 96 )
  love.graphics.setFont(font)
  love.graphics.setColor(57, 150, 153)
  love.graphics.printf("STACK THAT",  0, 65, 700, 'center')
  love.graphics.setColor(255, 255, 255)
  font = love.graphics.newFont("HelveticaNeueLTCom-Th.ttf", 48 )
  love.graphics.setFont(font)
  love.graphics.printf("Drag a circle",  0, 217, 700, 'center')
  love.graphics.printf("here",  0, 317, 700, 'center')
  love.graphics.printf("to select a level",  0, 417, 700, 'center')
  font = love.graphics.newFont("HelveticaNeueLTCom-Th.ttf", 18 )
  love.graphics.setFont(font)
end