local Menu = Game:addState('Menu')
local hsl = require('lib.hsl')
local getUVs = require('getUVs')
local TIME_TO_START = 3

local function circleInRectangle(cx, cy, cr, x1, y1, x2, y2)
  -- x1, y1 = x1 + cr, y1 + cr
  -- x2, y2 = x2 - cr, y2 - cr
  return cx >= x1 and cy >= y1 and cx <= x2 and cy <= y2
end

local function allSelected(possible_selections, selected)
  for i,selection in ipairs(possible_selections) do
    if not selected[selection] then
      return false
    end
  end
  return true
end

local quads = {
  attackers = {
    'player_1_body',
    'player_2_body'
  },
  defenders = {
    'player_1_life',
    'player_2_life'
  }
}

local function getMesh(sprite_name)
  local sprites = game.sprites
  local ua, va, ub, vb = getUVs(sprites, sprite_name)
  local radius = Player.RADIUS
  local mesh = g.newMesh({
    {-radius, -radius, ua, va},
    {-radius, radius, ua, vb},
    {radius, radius, ub, vb},
    {radius, -radius, ub, va},
  }, 'fan', 'static')
  mesh:setTexture(sprites.texture)
  return mesh
end

function Menu:enteredState()
  self.joysticks = love.joystick.getJoysticks()

  self.title_text_shader = g.newShader('shaders/title_text_shader.glsl')

  local w, h = push:getWidth(), push:getHeight()

  local keyboard_controls = {{
      directions = {
        w = {x = 0, y = -1},
        s = {x = 0, y = 1},
        a = {x = -1, y = 0},
        d = {x = 1, y = 0},
      },
      space = 'attack'
    }, {
      directions = {
        up = {x = 0, y = -1},
        down = {x = 0, y = 1},
        left = {x = -1, y = 0},
        right = {x = 1, y = 0},
      },
      ['return'] = 'attack'
    }
  }

  self.selectors = {}
  for i=1,2 do
    local x, y = w / 2, h / 2
    self.selectors[i] = {
      index = i,
      attacker = true,
      start_x = x, start_y = y,
      x = x, y = y,
      vx = 0, vy = 0,
      mesh = getMesh(quads.attackers[i]),
      joystick = self.joysticks[i],
      keyboard = keyboard_controls[i]
    }
    self.selectors[i + 2] = {
      index = i,
      defender = true,
      start_x = x, start_y = y,
      x = x, y = y,
      vx = 0, vy = 0,
      mesh = getMesh(quads.defenders[i]),
      joystick = self.joysticks[i],
      keyboard = keyboard_controls[i]
    }
  end

  self.player_selection_fields = {
    {
      gx = 0, gy = 0,
      x = 150, y = 150,
      w = 150, h = 150
    }, {
      gx = 1, gy = 0,
      x = w - 150, y = 150,
      w = 150, h = 150
    }, {
      gx = 1, gy = 1,
      x = w - 150, y = h - 150,
      w = 150, h = 150
    }, {
      gx = 0, gy = 1,
      x = 150, y = h - 150,
      w = 150, h = 150
    }
  }

  self.start_timer = nil
  self.players = {}
  self.t = 0
end

function Menu:update(dt)
  self.t = self.t + dt
  self.title_text_shader:send('time', self.t)
  for i=1,2 do
    local dx, dy = 0, 0
    if self.selectors[i].joystick then
      local joystick = self.selectors[i].joystick
      dx = joystick:getGamepadAxis("leftx")
      dy = joystick:getGamepadAxis("lefty")
      if math.abs(dx) < 0.2 then dx = 0 end
      if math.abs(dy) < 0.2 then dy = 0 end
    else
      local isDown = love.keyboard.isDown
      for k,v in pairs(self.selectors[i].keyboard.directions) do
        if isDown(k) then
          dx = dx + v.x
          dy = dy + v.y
        end
      end
    end

    if dx ~= 0 or dy ~= 0 then
      local p = self.selectors[i]
      local vx = dx * dt * Player.SPEED
      local vy = dy * dt * Player.SPEED
      p.vx = vx
      p.vy = vy
      p.x = p.x + vx
      p.y = p.y + vy

      p = self.selectors[i + 2]
      p.vx = -vx
      p.vy = -vy
      p.x = p.x - vx
      p.y = p.y - vy
    end
  end

  for i,field in ipairs(self.player_selection_fields) do
    self.players[field] = nil
    local ox, oy = field.x - field.w / 2, field.y - field.h / 2
    for _,p in ipairs(self.selectors) do
      if circleInRectangle(p.x, p.y, 20, ox, oy, ox + field.w, oy + field.h) then
        self.players[field] = p
        break
      end
    end
  end

  local playersSelected = allSelected(self.player_selection_fields, self.players)
  if not playersSelected and self.start_timer then
    self.start_timer = nil
  elseif playersSelected and self.start_timer == nil then
    self.start_timer = cron.after(TIME_TO_START, function()
      self:gotoState("Main")
    end)
  end

  if self.start_timer then self.start_timer:update(dt) end
end

function Menu:draw()
  push:start()

  g.draw(game.preloaded_images['title_bg.png'])

  for i,field in ipairs(self.player_selection_fields) do
    local ox, oy = field.x - field.w / 2, field.y - field.h / 2
    local alpha = 150
    g.setColor(255, 255, 255, alpha)
    for i,p in ipairs(self.selectors) do
      if circleInRectangle(p.x, p.y, 20, ox, oy, ox + field.w, oy + field.h) then
        if p.index == 1 then
          g.setColor(255,75,83,alpha)
        else
          g.setColor(25,151,255,alpha)
        end
        break
      end
    end
    g.rectangle('fill', ox, oy, field.w, field.h)
  end

  g.setColor(255, 255, 255)
  for i,p in ipairs(self.selectors) do
    if p.attacker then
      local angle = math.atan2(p.vy, p.vx) + math.pi / 2
      g.draw(p.mesh, p.x, p.y, angle)
      do
        local index = i == 1 and 1 or 2
        local quad = game.sprites.quads['player_' .. index .. '_sword']
        g.draw(game.sprites.texture, quad, p.x, p.y, angle + math.pi)
      end
    else
      g.draw(p.mesh, p.x, p.y, self.t * 1.5)
    end
  end

  g.push('all')
  g.setFont(self.preloaded_fonts['04b03_64'])
  if self.start_timer then
    local x, y = push:getDimensions()
    g.print(math.ceil(self.start_timer.time - self.start_timer.running), x / 2, y / 2)
  end
  g.setColor(0, 0, 0)
  g.printf('N E O N\nS A M U R A I', 2, push:getHeight() * 0.1 + 2, push:getWidth(), 'center')
  g.setColor(217, 17, 197)
  g.setShader(self.title_text_shader)
  g.printf('N E O N\nS A M U R A I', 0, push:getHeight() * 0.1, push:getWidth(), 'center')
  g.pop()

  push:finish()
end

function Menu:exitedState()
end

return Menu
