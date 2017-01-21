local Player = class('Player', Base)
Player.static.SPEED = 200
Player.static.RADIUS = 20
local radius = Player.RADIUS

local AttackCharacter = require('player.attack_character')
local DefenseCharacter = require('player.defense_character')
local getUVs = require('getUVs')

function Player:initialize(joystick, mesh, x1, y1, x2, y2)
  Base.initialize(self)

  self.joystick = joystick
  self.mesh = mesh

  local ax, ay = game.map:gridToPixel(x1, y1)
  local dx, dy = game.map:gridToPixel(x2, y2)
  local w, h = push:getWidth() / game.map.width, push:getHeight() / game.map.height
  self.attackers = {
    AttackCharacter:new(ax, ay, radius, 0, Player.SPEED)
  }
  self.defenders = {
    DefenseCharacter:new(dx, dy, radius, 0, Player.SPEED)
  }
end

function Player:update(dt)
  for _,attacker in ipairs(self.attackers) do
    attacker:update(dt)
  end

  local dx = self.joystick:getGamepadAxis("leftx")
  local dy = self.joystick:getGamepadAxis("lefty")
  if math.abs(dx) < 0.2 then dx = 0 end
  if math.abs(dy) < 0.2 then dy = 0 end
  local phi = math.atan2(dy, dx)

  for _,attacker in ipairs(self.attackers) do
    if dx ~= 0 or dy ~= 0 then attacker:setAngle(phi) end
    attacker:setLinearVelocity(dx * attacker.speed, dy * attacker.speed)
  end

  for _,defender in ipairs(self.defenders) do
    if dx ~= 0 or dy ~= 0 then defender:setAngle(phi + math.pi) end
    defender:setLinearVelocity(-dx * defender.speed, -dy * defender.speed)
  end
end

function Player:gamepadpressed(button)
  for _,attacker in ipairs(self.attackers) do
    attacker:gamepadpressed(button)
  end
end

function Player:gamepadreleased(button)
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
