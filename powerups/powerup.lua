local Powerup = class('Powerup', Base)
local DefenseCharacter = require('player.defense_character')

local powerup_shader = g.newShader('shaders/powerup.glsl')
Powerup.static.powerup_shader = powerup_shader

function Powerup:initialize(x, y, time_to_trigger)
  Base.initialize(self)

  assert(is_num(x))
  assert(is_num(y))
  assert(is_num(time_to_trigger) and time_to_trigger >= 0)

  self.x, self.y = x, y
  self.time_to_trigger = time_to_trigger

  local w, h = push:getWidth() / game.map.width * 0.5, push:getHeight() / game.map.height * 0.5
  self.body = love.physics.newBody(game.world, self.x, self.y, 'dynamic')
  local shape = love.physics.newRectangleShape(w, h)
  self.fixture = love.physics.newFixture(self.body, shape, 1)
  self.fixture:setSensor(true)
  self.fixture:setUserData(self)

  self.mesh = g.newMesh({
    {-w, -h, 0, 0},
    {-w, h, 0, 1},
    {w, h, 1, 1},
    {w, -h, 1, 0},
  }, 'fan', 'static')

  self.timer = nil
end

function Powerup:update(dt)
  if self.timer then
    self.timer:update(dt)
  end
end

function Powerup:draw()
  g.push('all')
  g.setColor(217, 17, 197)
  g.setShader(powerup_shader)
  g.translate(self.x, self.y)
  g.draw(self.mesh)
  if self.timer then
    g.setShader()
    g.setColor(0, 0, 0)
    g.setFont(game.preloaded_fonts['04b03_32'])
    local w, h = push:getWidth() / game.map.width * 0.5, push:getHeight() / game.map.height * 0.5
    g.printf(math.round(self.timer.time - self.timer.running, 1), -w / 2, -32 / 2, w, 'center')
  end
  g.pop()
end

function Powerup:trigger(triggerer)
  for i,powerup in ipairs(game.powerups) do
    if powerup == self then
      table.remove(game.powerups, i)
      self.body:destroy()
      break
    end
  end
end

function Powerup:begin_contact(other)
  if other and other:isInstanceOf(DefenseCharacter) then
    if self.time_to_trigger == 0 then
      self:trigger(other)
    elseif self.time_to_trigger > 0 then
      self.timer = cron.after(self.time_to_trigger, self.trigger, self, other)
    end
  end
end

function Powerup:end_contact(other)
  if other and other:isInstanceOf(DefenseCharacter) then
    if self.timer and self.timer.args[2] == other then
      self.timer = nil
    end
  end
end

return Powerup
