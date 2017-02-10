local QuickStart = Game:addState('QuickStart')
local getUVs = require('getUVs')

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

function QuickStart:enteredState()
  self.joysticks = love.joystick.getJoysticks()

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
