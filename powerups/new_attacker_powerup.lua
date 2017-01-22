local NewAttackerPowerup = class('NewAttackerPowerup', Powerup)
local getNextSpawnPoint = require('get_next_spawn_point')
local AttackCharacter = require('player.attack_character')
local TIME_TO_TRIGGER = 4

function NewAttackerPowerup:initialize(x, y)
  Powerup.initialize(self, x, y, TIME_TO_TRIGGER)

  self.colors = {{217/255, 17/255, 197/255}, {0.956, 0.682, 0.207}}
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
