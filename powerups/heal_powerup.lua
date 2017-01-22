local HealPowerup = class('HealPowerup', Powerup)
local getNextSpawnPoint = require('get_next_spawn_point')
local AttackCharacter = require('player.attack_character')

function HealPowerup:initialize(...)
  Powerup.initialize(self, ...)

  self.colors = {{0, 1, 0}, {0.956, 0.682, 0.207}}
end

function HealPowerup:trigger(triggerer)
  triggerer.health = triggerer.max_health
  triggerer.speed = triggerer.original_speed

  for i,powerup in ipairs(game.powerups) do
    if powerup == self then
      table.remove(game.powerups, i)
      self.body:destroy()
      break
    end
  end
end

return HealPowerup
