local Over = Game:addState('Over')
local MOVE_TO_ELLIPSE_TIME = 4

local function lerp(t, v0, v1, d)
  t = math.clamp(0, t / d, 1)
  return v0 + math.pow(t, 2) * (v1 - v0)
end

function Over:enteredState()
  self.winner = self.players[1]
  for i,player in ipairs(self.players) do
    if #player.defenders > 0 then
      self.winner = player
    end
  end
  self.t = 0

  local attacker = self.winner.attackers[1]
  attacker.start_x = attacker.x
  attacker.start_y = attacker.y
  local defender = self.winner.defenders[1]
  defender.start_x = defender.x
  defender.start_y = defender.y
end

function Over:update(dt)
  self.t = self.t + dt
  local ox, oy = push:getWidth() / 2, push:getHeight() / 2
  local ex1, ey1 = math.cos(self.t) * 200 + ox, math.sin(self.t) * 100 + oy
  local ex2, ey2 = math.cos(self.t + math.pi) * 200 + ox, math.sin(self.t + math.pi) * 100 + oy

  local attacker = self.winner.attackers[1]
  local defender = self.winner.defenders[1]
  attacker.x = lerp(self.t, attacker.start_x, ex1, MOVE_TO_ELLIPSE_TIME)
  attacker.y = lerp(self.t, attacker.start_y, ey1, MOVE_TO_ELLIPSE_TIME)
  defender.x = lerp(self.t, defender.start_x, ex2, MOVE_TO_ELLIPSE_TIME)
  defender.y = lerp(self.t, defender.start_y, ey2, MOVE_TO_ELLIPSE_TIME)
end

function Over:draw()
  push:start()

  self.map:draw()

  for i,powerup in ipairs(self.powerups) do
    powerup:draw()
  end

  g.push('all')
  g.setCanvas(self.light_overlay)
  g.clear(0, 0, 0, 255 * 0.6)
  g.setShader(self.player_light_falloff_shader)
  g.setBlendMode('multiply')
  g.setColor(255, 255, 255, 255 * 0.25)
  for _,static_light in ipairs(self.static_lights) do
    g.draw(static_light.mesh, static_light.x, static_light.y)
  end
  g.pop()
  g.draw(self.light_overlay)

  for i,player in ipairs(self.players) do
    player:draw()
  end

  g.push('all')
  g.setColor(0, 255, 0, 100)
  g.setLineWidth(5)
  for i,player in ipairs(self.players) do
    for i,defender in ipairs(player.defenders) do
      local radius = defender.radius
      local health_ratio = defender.health / defender.max_health
      g.arc('line', 'open', defender.x, defender.y, radius * 2, -math.pi / 2, health_ratio * math.pi * 2 - math.pi / 2, radius * 2)
    end
  end
  g.pop()

  g.setFont(game.preloaded_fonts['04b03_64'])
  g.printf('WINNER', 0, push:getHeight() / 2 - 32, push:getWidth(), 'center')

  push:finish()
end

function Over:keyreleased(key, scancode)
  if self.t >= MOVE_TO_ELLIPSE_TIME then
    self:gotoState('Menu')
  end
end

function Over:gamepadreleased(joystick, button)
  if self.t >= MOVE_TO_ELLIPSE_TIME then
    self:gotoState('Menu')
  end
end

function Over:exitedState()
end

return Over
