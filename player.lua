local Player = class('Player', Base)
Player.static.SPEED = 200
Player.static.RADIUS = 20
local radius = Player.RADIUS

local getUVs = require('getUVs')

local function physicsCharacter(char)
  char.body = love.physics.newBody(game.world, char.x, char.y, 'dynamic')
  local shape = love.physics.newCircleShape(radius)
  char.fixture = love.physics.newFixture(char.body, shape, 1)

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
    physicsCharacter({
      x = ax,
      y = ay,
      rotation = 0
    })
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

    if dx ~= 0 or dy ~= 0 then attacker.rotation = phi end
    attacker:setLinearVelocity(dx, dy)

    for _,defender in ipairs(self.defenders) do
      if dx ~= 0 or dy ~= 0 then defender.rotation = phi + math.pi end
      defender:setLinearVelocity(-dx, -dy)
    end
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
