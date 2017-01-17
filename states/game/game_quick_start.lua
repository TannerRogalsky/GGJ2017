local QuickStart = Game:addState('QuickStart')
local getUVs = require('getUVs')

local quads = {
  'robot1_gun',
  'soldier1_gun'
}

function QuickStart:enteredState()
  self.joysticks = love.joystick.getJoysticks()

  local w, h = push:getWidth(), push:getHeight()

  self.selectors = {}
  for i,v in ipairs(self.joysticks) do
    local x, y = w / 2, h / 2
    local sprite_name = quads[i]
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
    self.selectors[i] = {
      start_x = x, start_y = y,
      x = x, y = y,
      vx = 0, vy = 0,
      mesh = mesh,
      joystick = self.joysticks[i]
    }
    self.selectors[i + 2] = {
      start_x = x, start_y = y,
      x = x, y = y,
      vx = 0, vy = 0,
      mesh = mesh,
      joystick = self.joysticks[i]
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
  self.players = {
    [self.player_selection_fields[1]] = self.selectors[1],
    [self.player_selection_fields[2]] = self.selectors[2],
    [self.player_selection_fields[3]] = self.selectors[3],
    [self.player_selection_fields[4]] = self.selectors[4],
  }

  self:gotoState('Main')
end

function QuickStart:exitedState()
end

return QuickStart
