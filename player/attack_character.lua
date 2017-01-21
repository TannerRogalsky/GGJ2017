local Character = require('player.character')
local AttackCharacter = class('AttackCharacter', Character)

local Sword = require('player.sword')

function AttackCharacter:initialize(...)
  Character.initialize(self, ...)

  local body = love.physics.newBody(game.world, self.x, self.y, 'dynamic')
  local shape = love.physics.newRectangleShape(25, 0, 10, 50, math.pi / 2)
  local fixture = love.physics.newFixture(body, shape, 0.1)
  fixture:setSensor(true)

  local joint = love.physics.newRevoluteJoint(self.body, body, self.x, self.y, self.x, self.y, false, 0)
  joint:setLimits(-math.pi / 2, -math.pi / 2)
  joint:setLimitsEnabled(true)
  self.sword = Sword:new(body, fixture, joint)
  self.sword.fixture:setGroupIndex(self.owner.group_index)

  local oldSetAngle = self.setAngle
  function self:setAngle(phi)
    oldSetAngle(self, phi)
    if not joint:isMotorEnabled() then
      body:setAngle(phi - math.pi / 2)
    end
  end
end

function AttackCharacter:update(dt)
  local sword = self.sword
  sword.angle = sword.body:getAngle()
  local delta = sword.angle - self.body:getAngle()
  if delta > math.pi / 2 then
    local body = sword.body
    local joint = sword.joint
    joint:setMotorEnabled(false)
    joint:setLimits(-math.pi / 2, -math.pi / 2)
    body:setAngle(self.rotation - math.pi / 2)
    sword.swinging = false
  end
end

function AttackCharacter:gamepadpressed(button)
  if button == 'a' and self.sword.swinging == false then
    local body = self.sword.body
    local joint = self.sword.joint
    self.sword.swinging = true
    joint:setLimits(-math.pi / 2, math.pi / 2)
    joint:setMotorEnabled(true)
    joint:setMotorSpeed(math.pi * 6)
    joint:setMaxMotorTorque(100000)
  end
end

return AttackCharacter
