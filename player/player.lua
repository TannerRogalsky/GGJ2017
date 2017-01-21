local Player = class('Player', Base)
Player.static.SPEED = 200
Player.static.RADIUS = 20
local radius = Player.RADIUS

local AttackCharacter = require('player.attack_character')
local DefenseCharacter = require('player.defense_character')
local getUVs = require('getUVs')

function Player:initialize(joystick, attacker_mesh, defender_mesh, x1, y1, x2, y2, group_index)
  Base.initialize(self)

  assert(is_num(group_index))

  self.joystick = joystick
  self.attacker_mesh = attacker_mesh
  self.defender_mesh = defender_mesh
  self.group_index = group_index

  local ax, ay = game.map:gridToPixel(x1, y1)
  local dx, dy = game.map:gridToPixel(x2, y2)
  local w, h = push:getWidth() / game.map.width, push:getHeight() / game.map.height
  self.attackers = {
    AttackCharacter:new(self, ax, ay, radius, 0, Player.SPEED)
  }
  self.defenders = {
    DefenseCharacter:new(self, dx, dy, radius, 0, Player.SPEED)
  }

  self.t = 0
end

function Player:update(dt)
  self.t = self.t + dt
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
    g.draw(self.attacker_mesh, attacker.x, attacker.y, attacker.rotation + math.pi / 2)

    do
      local index = math.abs(self.group_index)
      local quad = game.sprites.quads['player_' .. index .. '_sword']
      g.draw(game.sprites.texture, quad, attacker.x, attacker.y, attacker.sword.angle)
    end
  end

  for _,defender in ipairs(self.defenders) do
    g.draw(self.defender_mesh, defender.x, defender.y, self.t * 1.5)
  end
end

return Player
