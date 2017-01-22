local Main = Game:addState('Main')
local printGrid = require('map.print_grid')
local symmetricalize = require('map.symmetricalize')
local raycasters = require('light.get_line_of_sight_points')
local buildLightOverlay = require('light.build_light_overlay')
local physicsDebugDraw = require('physics_debug_draw')
local physics_callbacks = require('physics_callbacks')
local getNextSpawnPoint = require('get_next_spawn_point')
local NewAttackerPowerup = require('powerups.new_attacker_powerup')
local HealPowerup = require('powerups.heal_powerup')
local healthBarStencil = require('health_bar_stencil')
local LIGHT_FALLOFF_DISTANCE = 250

local defenders_light_mesh = g.newMesh({
  {-LIGHT_FALLOFF_DISTANCE, -LIGHT_FALLOFF_DISTANCE},
  {-LIGHT_FALLOFF_DISTANCE, LIGHT_FALLOFF_DISTANCE},
  {LIGHT_FALLOFF_DISTANCE, LIGHT_FALLOFF_DISTANCE},
  {LIGHT_FALLOFF_DISTANCE, -LIGHT_FALLOFF_DISTANCE}
}, 'fan', 'static')

function Main:enteredState()
  local Camera = require('lib/camera')
  self.camera = Camera:new()

  self.t = 0
  self.world = love.physics.newWorld(0, 0)
  self.world:setCallbacks(unpack(physics_callbacks))

  local width, height = math.floor(16 * 0.4), math.floor(9 * 0.4)
  local seed = math.floor(love.math.random(math.pow(2, 53)))
  print(string.format('Seed: %u', seed))
  local grid = growingTree(width, height, {random = 1, newest = 1}, seed)
  grid = symmetricalize(grid, 'both')
  self.map = Map:new(grid)

  self.powerups = {}
  self.static_lights = {}
  do
    local x, y = self.map:gridToPixel(width + 0.5, height + 0.5)
    table.insert(self.static_lights, {
      x = x,
      y = y,
      mesh = g.newMesh(raycasters.slow(x, y), 'fan', 'static')
    })
  end
  for i=1,3 do
    local x, y = self.map:gridToPixel(getNextSpawnPoint(self))
    -- print(x, y)
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
      local field2 = self.player_selection_fields[i + 2]
      local selector2 = selection[field2]

      if selector1.defender then
        field1, field2 = field2, field1
        selector1, selector2 = selector2, selector1
      end

      local x1, y1 = field1.gx * (width * 2 - 1) + 1, field1.gy * (height * 2 - 1) + 1
      local x2, y2 = field2.gx * (width * 2 - 1) + 1, field2.gy * (height * 2 - 1) + 1
      self.players[i] = Player:new(selector1.joystick, selector1.mesh, selector2.mesh, x1, y1, x2, y2, -i)
      self.players[i].defenders[1].fixture:setMask(2)
    end

    self.players[1].color = {255/255,75/255,83/255}
    self.players[2].color = {25/255,151/255,255/255}
  end

  for i=1,5 do
    local x, y = self.map:gridToPixel(getNextSpawnPoint(self))
    self.powerups[i] = HealPowerup:new(x, y, 1)
  end

  self.light_overlay = g.newCanvas(g.getWidth(), g.getHeight(), 'normal')
  self.player_light_falloff_shader = g.newShader('shaders/player_light_falloff.glsl')
  self.player_light_falloff_shader:send('falloff_distance', LIGHT_FALLOFF_DISTANCE)

  g.setFont(self.preloaded_fonts['04b03_16'])
end

function Main:update(dt)
  self.t = self.t + dt
  Powerup.powerup_shader:send('time', self.t)
  self.world:update(dt)
  for i,player in ipairs(self.players) do
    player:update(dt)
  end

  for i,powerup in ipairs(self.powerups) do
    powerup:update(dt)
  end

  for i,player in ipairs(self.players) do
    for i=#player.defenders,1,-1 do
      if player.defenders[i].health <= 0 then
        table.remove(player.defenders, i)
      end
    end

    if #player.defenders <= 0 then
      self:gotoState('Over')
    end
  end
end

function Main:draw()
  push:start()
  self.camera:set()

  self.map:draw()

  for i,powerup in ipairs(self.powerups) do
    powerup:draw()
  end

  -- physicsDebugDraw()

  for i,player in ipairs(self.players) do
    player:draw()
  end

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
      g.draw(defenders_light_mesh, defender.x, defender.y)
    end
  end
  for _,static_light in ipairs(self.static_lights) do
    g.draw(static_light.mesh, static_light.x, static_light.y)
  end
  g.pop()
  g.draw(self.light_overlay)

  g.push('all')
  love.graphics.stencil(healthBarStencil, 'replace', 1)
  love.graphics.setStencilTest('greater', 0)
  for i,player in ipairs(self.players) do
    for _,defender in ipairs(player.defenders) do
      local quad = self.sprites.quads['player_' .. i .. '_life_ring']
      g.draw(self.sprites.texture, quad, defender.x, defender.y, 0, 2, 2, 32 / 2, 32 / 2)
    end
  end
  love.graphics.setStencilTest()
  g.pop()

  self.camera:unset()
  push:finish()

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
    self:gotoState('QuickStart')
  end
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
  for i,player in ipairs(self.players) do
    if player.joystick == joystick then
      player:gamepadpressed(button)
    end
  end
end

function Main:gamepadreleased(joystick, button)
  for i,player in ipairs(self.players) do
    if player.joystick == joystick then
      player:gamepadreleased(button)
    end
  end
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.world:destroy()
  self.camera = nil
end

return Main
