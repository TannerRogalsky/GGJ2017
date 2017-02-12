local LightingTest = Game:addState('LightingTest')
local physicsDebugDraw = require('physics_debug_draw')
local buildLightOverlay = require('light.build_light_overlay')
LIGHT_FALLOFF_DISTANCE = 250

function LightingTest:enteredState()
  self.origin = {x = g.getWidth() / 2, y = g.getHeight() / 2}

  self.world = love.physics.newWorld(0, 0)

  local body = love.physics.newBody(self.world, 0, 0, 'static')
  local world_shape = love.physics.newPolygonShape(150 + 200, 100 + 200, 200 + 200, 100 + 200, 175 + 200, 150 + 200)
  local world_fixture = love.physics.newFixture(body, world_shape)

  self.map = {body = body}

  self.light_bbox = love.physics.newBody(self.world, 0, 0, 'static')
  local light_bbox_shape = love.physics.newChainShape(true,
    -LIGHT_FALLOFF_DISTANCE, -LIGHT_FALLOFF_DISTANCE,
    -LIGHT_FALLOFF_DISTANCE, LIGHT_FALLOFF_DISTANCE,
    LIGHT_FALLOFF_DISTANCE, LIGHT_FALLOFF_DISTANCE,
    LIGHT_FALLOFF_DISTANCE, -LIGHT_FALLOFF_DISTANCE)
  self.light_bbox_fix = love.physics.newFixture(self.light_bbox, light_bbox_shape)
  self.light_bbox_fix:setSensor(true)

  self.light_overlay = g.newCanvas(g.getWidth(), g.getHeight(), 'normal')
  self.player_light_falloff_shader = g.newShader('shaders/player_light_falloff.glsl')
  self.player_light_falloff_shader:send('falloff_distance', LIGHT_FALLOFF_DISTANCE)
  g.setBackgroundColor(100, 100, 100)
end

local t = 0
function LightingTest:update(dt)
  t = t + dt
  self.light_bbox:setPosition(self.origin.x, self.origin.y)
  self.light_bbox:setAngle(t / 2)
end

function LightingTest:draw()
  self.origin.x, self.origin.y = love.mouse.getPosition()

  -- g.setColor(255, 255, 255, 100)
  -- buildLightOverlay(self.origin.x, self.origin.y)

  do
    g.push('all')
    g.setCanvas(self.light_overlay)
    g.clear(0, 0, 0, 255 * 0.6)
    if love.keyboard.isDown('space') then
      g.setWireframe(true)
    else
      g.setShader(self.player_light_falloff_shader)
    end
    g.setBlendMode('multiply')
    g.setColor(255, 255, 255, 255 * 0.25)

    buildLightOverlay(self.origin.x, self.origin.y, self.light_filter)

    g.pop()
    g.draw(self.light_overlay)
  end

  physicsDebugDraw(self.world)

  g.print(love.timer.getFPS())
end

function LightingTest:exitedState()
end

return LightingTest
