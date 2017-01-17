local Main = Game:addState('Main')
local printGrid = require('map.print_grid')
local symmetricalize = require('map.symmetricalize')
local raycasters = require('light.get_line_of_sight_points')
local buildLightOverlay = require('light.build_light_overlay')

local function physicsDebugDraw()
  for _,body in ipairs(game.world:getBodyList()) do
    local x, y = body:getPosition()
    for _,fixture in ipairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      local shapeType = shape:getType()
      g.push()
      g.translate(x, y)
      if shapeType == 'circle' then
        local x, y = shape:getPoint()
        g.circle('fill', x, y, shape:getRadius())
      elseif shapeType == 'edge' then
        g.line(shape:getPoints())
      elseif shapeType == 'polygon' then
        g.polygon('line', shape:getPoints())
      end
      g.pop()
    end
  end
end

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.world = love.physics.newWorld(0, 0)

  local width, height = math.floor(16 * 0.4), math.floor(9 * 0.4)
  local seed = math.floor(love.math.random(math.pow(2, 53)))
  print(string.format("Seed: %u", seed))
  local grid = growingTree(width, height, {random = 1, newest = 1}, seed)
  grid = symmetricalize(grid, 'both')
  self.map = Map:new(grid)

  self.static_lights = {}
  for i=1,3 do
    local x, y = self.map:gridToPixel(love.math.random(width * 2), love.math.random(height * 2))
    table.insert(self.static_lights, {
      x = x,
      y = y,
      mesh = g.newMesh(raycasters.slow(x, y), 'fan', 'static')
    })
  end

  do -- DEAR GOD
    local selection = self.players
    self.players = {}
    for i=1,2 do
      local field1 = self.player_selection_fields[i]
      local selector1 = selection[field1]
      local x1, y1 = field1.gx * (width * 2 - 1) + 1, field1.gy * (height * 2 - 1) + 1
      local field2 = self.player_selection_fields[i + 2]
      local selector2 = selection[field2]
      local x2, y2 = field2.gx * (width * 2 - 1) + 1, field2.gy * (height * 2 - 1) + 1
      self.players[i] = Player:new(selector1.joystick, selector1.mesh, x1, y1, x2, y2)
    end
  end

  self.light_overlay = g.newCanvas(g.getWidth(), g.getHeight(), 'normal')
  self.player_light_falloff_shader = g.newShader('shaders/player_light_falloff.glsl')
  self.player_light_falloff_shader:send('falloff_distance', 250)

  g.setFont(self.preloaded_fonts["04b03_16"])
end

function Main:update(dt)
  self.world:update(dt)
  for i,player in ipairs(self.players) do
    player:update(dt)
  end
end

function Main:draw()
  push:start()
  self.camera:set()

  self.map:draw()

  -- physicsDebugDraw()

  g.push('all')
  g.setCanvas(self.light_overlay)
  g.clear(0, 0, 0, 255 * 0.6)
  g.setShader(self.player_light_falloff_shader)
  g.setBlendMode('multiply')
  g.setColor(255, 255, 255, 255 * 0.25)
  for i,player in ipairs(self.players) do
    for _,attacker in ipairs(player.attackers) do
      buildLightOverlay(attacker.x, attacker.y)
    end
    for _,defender in ipairs(player.defenders) do
      buildLightOverlay(defender.x, defender.y)
    end
  end
  for _,static_light in ipairs(self.static_lights) do
    g.draw(static_light.mesh, static_light.x, static_light.y)
  end
  g.pop()

  for i,player in ipairs(self.players) do
    player:draw()
  end

  self.camera:unset()
  push:finish()

  g.draw(self.light_overlay)

  if self.debug then
    g.setColor(0, 255, 0)
    g.print(love.timer.getFPS(), 0, 0)
    g.setColor(255, 255, 255)
  end
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
  if key == 'r' then
    self:gotoState('Main')
  end
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.world:destroy()
  self.camera = nil
end

return Main
