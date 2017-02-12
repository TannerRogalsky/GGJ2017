local HealPowerup = class('HealPowerup', Powerup)
local getNextSpawnPoint = require('get_next_spawn_point')
local AttackCharacter = require('player.attack_character')
local TIME_TO_TRIGGER = 2

function HealPowerup:initialize(x, y)
  Powerup.initialize(self, x, y, TIME_TO_TRIGGER)

  self.colors = {{59 / 255, 233 / 255, 111 / 255}, {0.5, 0.5, 0.7}}

  local old_draw = self.draw
  function self:draw()
    old_draw(self)
    local sprites = game.sprites
    local quad = sprites.quads.powerup_health
    local w, h = push:getWidth() / game.map.width, push:getHeight() / game.map.height
    local alpha = 255
    if self.timer then
      alpha = 50
    end
    g.setColor(255, 255, 255, alpha)
    g.draw(sprites.texture, quad, self.x - w / 4, self.y - h / 4, 0, 2, 2)
    g.setColor(255, 255, 255)
  end
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
