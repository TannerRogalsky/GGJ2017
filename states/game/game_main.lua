local Main = Game:addState('Main')
local printGrid = require('map.print_grid')
local symmetricalize = require('map.symmetricalize')

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

local ray_hits = {}
local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
  table.insert(ray_hits, {
    object = fixture:getUserData(),
    x = x,
    y = y,
    xn = xn,
    yn = yn,
    fraction = fraction
  })
  return 1
end

local function rayCast(world, x1, y1, x2, y2, callback)
  ray_hits = {}
  world:rayCast(x1, y1, x2, y2, worldRayCastCallback)
  return ray_hits
end

local function rayCastClosest(world, x1, y1, x2, y2, callback)
  rayCast(world, x1, y1, x2, y2, callback)
  if #ray_hits > 0 then
    local closest_hit = ray_hits[1]
    for i,hit in ipairs(ray_hits) do
      if hit.fraction < closest_hit.fraction then
        closest_hit = hit
      end
    end

    return closest_hit
  else
    return nil
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

  self.players = {
    Player:new()
  }

  self.sprites = require('images.sprites')

  self.mesh = g.newMesh(#self.map.body:getFixtureList() * 4 * 2, 'fan', 'stream')

  g.setFont(self.preloaded_fonts["04b03_16"])
end

function Main:update(dt)
  self.world:update(dt)
  for i,player in ipairs(self.players) do
    player:update(dt)
  end
end

local function len(x, y)
  return x * x + y * y
end

local function getIsLess(a, b)
  if a[1] >= 0 and b[1] < 0 then return true end
  if a[1] < 0 and b[1] >= 0 then return false end
  if a[1] == 0 and b[1] == 0 then
    if a[2] >= 0 or b[2] >= 0 then return a[2] > b[2] end
    return b[2] > a[2]
  end

  local det = a[1] * b[2] - b[1] * a[2]
  if det < 0 then
    return true
  elseif det > 0 then
    return false
  end

  local d1 = a[1] * a[1] + a[2] * a[2]
  local d2 = b[1] * b[1] + b[2] * b[2]
  return d1 > d2
end

function Main:draw()
  push:start()
  self.camera:set()

  self.map:draw()

  physicsDebugDraw()

  do
    local MAX_DIST = 200
    local x1, y1 = self.players[1].attackers[1].x, self.players[1].attackers[1].y

    local body = self.map.body
    local bx, by = body:getPosition()
    local hits = {}
    for _,fixture in ipairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      local points = {shape:getPoints()}
      for i=1,8,2 do
        local x2, y2 = bx + points[i], by + points[i + 1]
        -- if len(x1 - x2, y1 - y2) <= MAX_DIST * MAX_DIST then
          local hit = rayCastClosest(self.world, x1, y1, x2, y2)
          if hit then
            table.insert(hits, {hit.x - x1, hit.y - y1})
          end
        -- end
      end
    end

    table.sort(hits, getIsLess)
    table.insert(hits, {hits[1][1], hits[1][2]})
    table.insert(hits, 1, {0, 0})
    g.setColor(255, 255, 255)
    self.mesh:setVertices(hits)
    self.mesh:setDrawRange(1, #hits)
    g.setWireframe(love.keyboard.isDown('space'))
    g.draw(self.mesh, x1, y1)
  end

  for i,player in ipairs(self.players) do
    player:draw()
  end

  self.camera:unset()
  push:finish()
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
