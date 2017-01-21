local NewAttackerPowerup = class('NewAttackerPowerup', Powerup)
local getNextSpawnPoint = require('get_next_spawn_point')
local AttackCharacter = require('player.attack_character')

function NewAttackerPowerup:initialize(...)
  Powerup.initialize(self, ...)
end

function NewAttackerPowerup:trigger(triggerer)
  local player = triggerer.owner
  local x, y = game.map:gridToPixel(getNextSpawnPoint(game))
  table.insert(player.attackers, AttackCharacter:new(player, x, y, Player.RADIUS, 0, Player.SPEED))

  for i,powerup in ipairs(game.powerups) do
    if powerup == self then
      table.remove(game.powerups, i)
      self.body:destroy()
      break
    end
  end
end

return NewAttackerPowerup
