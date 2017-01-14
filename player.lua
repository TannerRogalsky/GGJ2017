local Player = class('Player', Base)
Player.static.SPEED = 200

local getUVs = require('getUVs')

local radius = 20

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

function Player:initialize()
  Base.initialize(self)

  self.joystick = love.joystick.getJoysticks()[1]

  do
    local sprite_name = 'robot1_gun'
    local sprites = require('images.sprites')
    local ua, va, ub, vb = getUVs(sprites, sprite_name)
    self.mesh = g.newMesh({
      {-radius, -radius, ua, va},
      {-radius, radius, ua, vb},
      {radius, radius, ub, vb},
      {radius, -radius, ub, va},
    }, 'fan', 'static')
    self.mesh:setTexture(sprites.texture)
  end

  local ax, ay = game.map:gridToPixel(1, 1)
  local dx, dy = game.map:gridToPixel(game.map.width, game.map.height)
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
    local phi = math.atan2(dy, dx)

    local dx, dy = dx * Player.SPEED, dy * Player.SPEED

    attacker.rotation = phi
    attacker:setLinearVelocity(dx, dy)

    for _,defender in ipairs(self.defenders) do
      defender.rotation = phi + math.pi
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
