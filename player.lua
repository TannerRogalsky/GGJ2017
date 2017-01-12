local Player = class('Player', Base)
Player.static.SPEED = 1000

local radius = 20

local function physicsCharacter(char)
  char.body = love.physics.newBody(game.world, char.x, char.y, 'dynamic')
  local shape = love.physics.newCircleShape(radius)
  char.fixture = love.physics.newFixture(char.body, shape, 0.01)
  -- char.body:setMass(0.05)
  char.body:setLinearDamping(5)

  function char:setPosition(x, y)
    char.x, char.y = x, y
    char.body:setPosition(x, y)
  end

  function char:applyForce(fx, fy)
    char.body:applyForce(fx, fy)
    char.x = char.body:getX()
    char.y = char.body:getY()
  end

  return char
end

function Player:initialize(args)
  Base.initialize(self)

  self.joystick = love.joystick.getJoysticks()[1]

  do
    local sprite_name = 'robot1_gun'
    local sprites = require('images.sprites')
    local ua, va, ub, vb = sprites:getUVs(sprite_name)
    self.mesh = g.newMesh({
      {-radius, -radius, ua, va},
      {-radius, radius, ua, vb},
      {radius, radius, ub, vb},
      {radius, -radius, ub, va},
    }, 'fan', 'static')
    self.mesh:setTexture(sprites.texture)
  end

  self.attackers = {
    physicsCharacter({
      x = 100,
      y = 100,
      rotation = 0
    })
  }
  self.defenders = {
    physicsCharacter({
      x = 600,
      y = 500,
      rotation = 0
    })
  }
end

function Player:update(dt)
  for _,attacker in ipairs(self.attackers) do
    local dx = self.joystick:getGamepadAxis("leftx")
    local dy = self.joystick:getGamepadAxis("lefty")
    local phi = math.atan2(dy, dx)

    local fx, fy = dx * dt * Player.SPEED, dy * dt * Player.SPEED

    attacker.rotation = phi
    attacker:applyForce(fx, fy)

    for _,defender in ipairs(self.defenders) do
      defender.rotation = phi + math.pi
      defender:applyForce(-dx * dt * Player.SPEED, -dy * dt * Player.SPEED)
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
