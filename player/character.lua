local Character = class('Character', Base)

function Character:initialize(owner, x, y, radius, rotation, speed)
  Base.initialize(self)

  assert(owner:isInstanceOf(Player))
  assert(is_num(x))
  assert(is_num(y))
  assert(is_num(radius))
  assert(is_num(rotation))
  assert(is_num(speed))

  self.owner = owner
  self.x, self.y = x, y
  self.radius = radius
  self.rotation = rotation
  self.speed = speed

  self.body = love.physics.newBody(game.world, self.x, self.y, 'dynamic')
  local shape = love.physics.newCircleShape(self.radius)
  self.fixture = love.physics.newFixture(self.body, shape, 1)
  self.body:setFixedRotation(true)
  self.fixture:setUserData(self)
end

function Character:setPositionFromBody()
  self.x = self.body:getX()
  self.y = self.body:getY()
end

function Character:setPosition(x, y)
  self.body:setPosition(x, y)
  self:setPositionFromBody()
end

function Character:applyForce(fx, fy)
  self.body:applyForce(fx, fy)
  self:setPositionFromBody()
end

function Character:setLinearVelocity(dx, dy)
  self.body:setLinearVelocity(dx, dy)
  self:setPositionFromBody()
end

function Character:setAngle(phi)
  self.rotation = phi
  self.body:setAngle(phi)
end

return Character
