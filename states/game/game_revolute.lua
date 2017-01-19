local Revolute = Game:addState('Revolute')

local function physicsDebugDraw()
  for _,body in ipairs(game.world:getBodyList()) do
    local x, y = body:getPosition()
    g.push()
    g.translate(x, y)
    g.setColor(255, 255, 255)
    for _,fixture in ipairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      local shapeType = shape:getType()
      if shapeType == 'circle' then
        local x, y = shape:getPoint()
        local phi = body:getAngle()
        g.circle('line', x, y, shape:getRadius())
        g.line(x, y, x + math.cos(phi) * shape:getRadius(), y + math.sin(phi) * shape:getRadius())
      elseif shapeType == 'edge' then
        g.line(shape:getPoints())
      elseif shapeType == 'polygon' then
        g.polygon('line', shape:getPoints())
      end
    end

    g.setColor(0, 0, 255)
    for _,joint in ipairs(body:getJointList()) do
      local x1, y1, x2, y2 = joint:getAnchors()
      g.circle('fill', x1, y1, 3)
      g.circle('fill', x2, y2, 3)
    end
    g.pop()
  end
end

function Revolute:enteredState()
  self.world = love.physics.newWorld(0, 10)

  mx, my = push:getWidth() / 2, push:getHeight() / 2
  radius = 30

  do
    self.body3 = love.physics.newBody(self.world, mx, push:getHeight() * 0.6, 'static')
    local shape3 = love.physics.newRectangleShape(push:getWidth(), 10)
    self.fixture3 = love.physics.newFixture(self.body3, shape3, 1)
  end

  do
    self.body1 = love.physics.newBody(self.world, mx, my, 'dynamic')
    local shape1 = love.physics.newCircleShape(0, 0, radius)
    self.fixture1 = love.physics.newFixture(self.body1, shape1, 1)
    print(self.body1:getMass())
  end

  do
    self.body2 = love.physics.newBody(game.world, mx, my, 'dynamic')
    local shape = love.physics.newRectangleShape(0, 0, radius * 4, radius * 4)
    self.fixture2 = love.physics.newFixture(self.body2, shape, 1)
    print(self.body2:getMass())
  end

  do
    self.joint = love.physics.newRevoluteJoint(self.body1, self.body2, 0, 0, false)
    -- self.joint:setMotorSpeed(math.pi * 2)
    -- self.joint:setMotorEnabled(true)
    -- self.joint:setMaxMotorTorque(100000)
    print(self.joint:getMaxMotorTorque(), self.joint:isMotorEnabled())
  end
end

function Revolute:update(dt)
  self.world:update(dt)
end

function Revolute:draw()
  physicsDebugDraw()
end

function Revolute:exitedState()
end

return Revolute
