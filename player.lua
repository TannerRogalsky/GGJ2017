local Player = class('Player', Base)
Player.static.SPEED = 200
Player.static.RADIUS = 20
local radius = Player.RADIUS

local getUVs = require('getUVs')

local function physicsCharacter(char)
  char.body = love.physics.newBody(game.world, char.x, char.y, 'dynamic')
  local shape = love.physics.newCircleShape(radius)
  char.fixture = love.physics.newFixture(char.body, shape, 1)
  char.body:setFixedRotation(true)

  function char:setPositionFromBody()
    char.x = char.body:getX()
    char.y = char.body:getY()
  end

  function char:setPosition(x, y)
    char.body:setPosition(x, y)
    char:setPositionFromBody()
  end

  function char:applyForce(fx, fy)
    char.body:applyForce(fx, fy)
    char:setPositionFromBody()
  end

  function char:setLinearVelocity(dx, dy)
    char.body:setLinearVelocity(dx, dy)
    char:setPositionFromBody()
  end

  function char:setAngle(phi)
    char.rotation = phi
    char.body:setAngle(phi)
  end

  return char
end

local function swordCharacter(char)
  local jx, jy = char.x, char.y
  local body = love.physics.newBody(game.world, jx, jy, 'dynamic')
  local shape = love.physics.newRectangleShape(25, 0, 10, 50, math.pi / 2)
  local fixture = love.physics.newFixture(body, shape, 0.1)
  fixture:setSensor(true)
  -- body:setActive(false)

  local joint = love.physics.newRevoluteJoint(char.body, body, jx, jy, jx, jy, false, 0)
  joint:setLimits(-math.pi / 2, -math.pi / 2)
  joint:setLimitsEnabled(true)
  -- joint:setLimits(0, 0)
  char.sword = {
    body = body,
    joint = joint
  }

  local oldSetAngle = char.setAngle
  function char:setAngle(phi)
    oldSetAngle(char, phi)
    -- joint:setLimits(phi, phi)
    body:setAngle(phi - math.pi / 2)
  end

  return char
end

function Player:initialize(joystick, mesh, x1, y1, x2, y2)
  Base.initialize(self)

  self.joystick = joystick
  self.mesh = mesh

  local ax, ay = game.map:gridToPixel(x1, y1)
  local dx, dy = game.map:gridToPixel(x2, y2)
  local w, h = push:getWidth() / game.map.width, push:getHeight() / game.map.height
  self.attackers = {
    swordCharacter(physicsCharacter({
      x = ax,
      y = ay,
      rotation = 0
    }))
  }
  self.defenders = {
    physicsCharacter({
      x = dx,
      y = dy,
      rotation = 0
    })
  }
end

function Player:update(dt)
  for _,attacker in ipairs(self.attackers) do
    local dx = self.joystick:getGamepadAxis("leftx")
    local dy = self.joystick:getGamepadAxis("lefty")
    if math.abs(dx) < 0.2 then dx = 0 end
    if math.abs(dy) < 0.2 then dy = 0 end
    local phi = math.atan2(dy, dx)

    local dx, dy = dx * Player.SPEED, dy * Player.SPEED

    if dx ~= 0 or dy ~= 0 then attacker:setAngle(phi) end
    attacker:setLinearVelocity(dx, dy)

    for _,defender in ipairs(self.defenders) do
      if dx ~= 0 or dy ~= 0 then defender:setAngle(phi + math.pi) end
      defender:setLinearVelocity(-dx, -dy)
    end
  end
end

function Player:gamepadpressed(button)
  if button == 'a' then
    local body = self.attackers[1].sword.body
    -- body:setActive(true)
    -- body:setAngle(-math.pi / 2)
    local joint = self.attackers[1].sword.joint
    joint:setLimits(-math.pi / 2, math.pi / 2)
    joint:setMotorEnabled(true)
    joint:setMotorSpeed(math.pi * 10)
    joint:setMaxMotorTorque(100000)
  end
end

function Player:gamepadreleased(button)
  if button == 'a' then
    local body = self.attackers[1].sword.body
    local joint = self.attackers[1].sword.joint
    -- body:setActive(false)
    joint:setMotorEnabled(false)
    joint:setLimits(-math.pi / 2, -math.pi / 2)
  end
end

function Player:draw()
  for i,attacker in ipairs(self.attackers) do
    g.draw(self.mesh, attacker.x, attacker.y, attacker.rotation)
  end

  for _,defender in ipairs(self.defenders) do
    g.draw(self.mesh, defender.x, defender.y, defender.rotation)
  end
end

return Player
