local Character = require('player.character')
local DefenseCharacter = class('DefenseCharacter', Character)
local SPEED_SCALE = 1.05
local Sword = require('player.sword')

function DefenseCharacter:initialize(...)
  Character.initialize(self, ...)

  self.max_health = 10
  self.health = self.max_health
  self.original_speed = self.speed

  self.fixture:setGroupIndex(self.owner.group_index)
end

function DefenseCharacter:begin_contact(other)
  if other and other:isInstanceOf(Sword) then
    self.health = self.health - other.damage
    local health_ratio = self.health / self.max_health
    -- print(health_ratio, 1 - health_ratio)
    self.speed = self.original_speed * ((1 - health_ratio) * SPEED_SCALE + 1)
  end
end

return DefenseCharacter
