local Map = class('Map', Base)
local MAP_CONSTANTS = require('map.constants')
local N, S, E, W = unpack(MAP_CONSTANTS.DIRECTIONS)
local NEC, SEC, SWC, NWC = 16, 32, 64, 128
local buildExtrusionPhysicsTerrain = require('map.build_extrusion_physics_terrain')

local bitmask = {
  [0] = 'tile_342',
  [N] = 'tile_286',
  [E] = 'tile_313',
  [S] = 'tile_312',
  [W] = 'tile_285',
  [N + E] = 'tile_307',
  [N + W] = 'tile_308',
  [N + S] = 'tile_309',
  [S + E] = 'tile_280',
  [S + W] = 'tile_281',
  [E + W] = 'tile_282',
  [S + E + W] = 'tile_283',
  [N + E + W] = 'tile_284',
  [N + S + E] = 'tile_310',
  [N + S + W] = 'tile_311',
  [N + S + E + W] = 'tile_341',
  [NEC + N + E] = 'tile_314',
  [NWC + N + W] = 'tile_315',
  [SEC + S + E] = 'tile_287',
  [SWC + S + W] = 'tile_288',
  [NEC + N + E + W] = 'tile_419',
  [NWC + N + E + W] = 'tile_420',
  [SEC + S + E + W] = 'tile_392',
  [SWC + S + E + W] = 'tile_393',
  [NEC + N + S + E] = 'tile_417',
  [SEC + N + S + E] = 'tile_390',
  [NWC + N + S + W] = 'tile_418',
  [SWC + N + S + W] = 'tile_391',
  [NEC + NWC + N + E + W] = 'tile_366',
  [SEC + SWC + S + E + W] = 'tile_365',
  [NEC + SEC + N + S + E] = 'tile_338',
  [NWC + SWC + N + S + W] = 'tile_339',
  [NEC + NWC + N + S + E + W] = 'tile_336',
  [SEC + SWC + N + S + E + W] = 'tile_337',
  [NWC + SWC + N + S + E + W] = 'tile_363',
  [NEC + SEC + N + S + E + W] = 'tile_364',
  [SWC + NWC + NEC + N + S + E + W] = 'tile_334',
  [SEC + NWC + NEC + N + S + E + W] = 'tile_335',
  [SEC + SWC + NEC + N + S + E + W] = 'tile_362',
  [SEC + SWC + NWC + N + S + E + W] = 'tile_361',
  [SEC + SWC + NWC + NEC + N + S + E + W] = 'tile_340',
}

local function applyNotCornerBit(grid)
  local width, height = #grid[1], #grid
  for y=1,height do
    for x=1,width do
      if x + 1 >= 1 and x + 1 <= width and
         y + 1 >= 1 and y + 1 <= height and
         bit.band(grid[y][x], E) ~= 0 and
         bit.band(grid[y][x], S) ~= 0 and
         bit.band(grid[y][x + 1], S) ~= 0 and
         bit.band(grid[y + 1][x], E) ~= 0 then
        grid[y][x] = grid[y][x] + SEC
      end
      if x - 1 >= 1 and x - 1 <= width and
         y + 1 >= 1 and y + 1 <= height and
         bit.band(grid[y][x], W) ~= 0 and
         bit.band(grid[y][x], S) ~= 0 and
         bit.band(grid[y][x - 1], S) ~= 0 and
         bit.band(grid[y + 1][x], W) ~= 0 then
        grid[y][x] = grid[y][x] + SWC
      end
      if x - 1 >= 1 and x - 1 <= width and
         y - 1 >= 1 and y - 1 <= height and
         bit.band(grid[y][x], W) ~= 0 and
         bit.band(grid[y][x], N) ~= 0 and
         bit.band(grid[y][x - 1], N) ~= 0 and
         bit.band(grid[y - 1][x], W) ~= 0 then
        grid[y][x] = grid[y][x] + NWC
      end
      if x + 1 >= 1 and x + 1 <= width and
         y - 1 >= 1 and y - 1 <= height and
         bit.band(grid[y][x], E) ~= 0 and
         bit.band(grid[y][x], N) ~= 0 and
         bit.band(grid[y][x + 1], N) ~= 0 and
         bit.band(grid[y - 1][x], E) ~= 0 then
        grid[y][x] = grid[y][x] + NEC
      end
    end
  end
end

local function findDeadEnds(grid)
  local deadends = {}
  for y=1,#grid do
    for x=1,#grid[1] do
      if grid[y][x] == N or grid[y][x] == S or grid[y][x] == E or grid[y][x] == W then
        table.insert(deadends, {x = x, y = y})
      end
    end
  end
  return deadends
end

local function getViewport(quad, texture)
  local w, h = texture:getDimensions()
  local qx, qy, qw, qh = quad:getViewport()
  return qx / w, qy / h, qw / w, qh / h
end

local function buildSpriteBatch(grid, width, height)
  local sprites = game.sprites
  local w, h = push:getWidth() / width, push:getHeight() / height
  local indices = {}
  local vertices = {}
  local px, py

  local index = 0
  for y=1,height do
    py = (y - 1) * h
    for x=1,width do
      px = (x - 1) * w
      local bits = grid[y][x]
      local tile_name = bitmask[bits]
      local quad = sprites.quads[tile_name]
      local mask_quad = sprites.quads[tile_name .. '_mask']
      local mqx, mqy, mqw, mqh = getViewport(mask_quad, sprites.texture)
      local qx, qy, qw, qh = getViewport(quad, sprites.texture)

      vertices[index * 4 + 0 + 1] = {px, py, qx, qy, 255, 255, 255, 255, mqx, mqy}
      vertices[index * 4 + 1 + 1] = {px, py + h, qx, qy + qh, 255, 255, 255, 255, mqx, mqy + mqh}
      vertices[index * 4 + 2 + 1] = {px + w, py, qx + qw, qy, 255, 255, 255, 255, mqx + mqw, mqy}
      vertices[index * 4 + 3 + 1] = {px + w, py + h, qx + qw, qy + qh, 255, 255, 255, 255, mqx + mqw, mqy + mqh}

      table.insert(indices, index * 4 + 0 + 1)
      table.insert(indices, index * 4 + 1 + 1)
      table.insert(indices, index * 4 + 2 + 1)
      table.insert(indices, index * 4 + 1 + 1)
      table.insert(indices, index * 4 + 2 + 1)
      table.insert(indices, index * 4 + 3 + 1)

      index = index + 1
    end
  end

  local mesh = g.newMesh({
    {'VertexPosition', 'float', 2}, -- The x,y position of each vertex.
    {'VertexTexCoord', 'float', 2}, -- The u,v texture coordinates of each vertex.
    {'VertexColor', 'byte', 4},     -- The r,g,b,a color of each vertex.
    {'VertexMaskCoord', 'float', 2},
  }, vertices, 'triangles', 'static')
  mesh:setTexture(sprites.texture)
  mesh:setVertexMap(indices)

  return mesh
end

function Map:initialize(grid)
  Base.initialize(self)

  self.grid = grid
  applyNotCornerBit(self.grid)
  self.width, self.height = #self.grid[1], #self.grid

  local size = 20
  local w, h = push:getWidth() / self.width, push:getHeight() / self.height
  self.body = buildExtrusionPhysicsTerrain(game.world, grid, size, size / (w / h))
  self.vertices = {}
  for i,fixture in ipairs(self.body:getFixtureList()) do
    local x1, y1, x2, y2, x3, y3, x4, y4 = fixture:getShape():getPoints()
    table.insert(self.vertices, {x1, y1})
    table.insert(self.vertices, {x2, y2})
    table.insert(self.vertices, {x3, y3})
    table.insert(self.vertices, {x4, y4})
  end

  self.spritebatch = buildSpriteBatch(self.grid, self.width, self.height)

  self.deadends = findDeadEnds(self.grid)
end

function Map:draw()
  g.draw(self.spritebatch)
end

function Map:gridToPixel(x, y)
  local width, height = #self.grid[1], #self.grid
  local w, h = push:getWidth() / width, push:getHeight() / height
  return (x - 0.5) * w, (y - 0.5) * h
end

return Map
