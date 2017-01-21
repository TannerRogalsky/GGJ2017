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

local function buildSpriteBatch(grid, width, height)
  local sprites = game.sprites
  local batch = g.newSpriteBatch(sprites.texture, width * height, 'static')
  local w, h = push:getWidth() / width, push:getHeight() / height
  local px, py
  for y=1,height do
    py = (y - 1) * h
    for x=1,width do
      px = (x - 1) * w
      local bits = grid[y][x]
      local tile_name = bitmask[bits]
      local quad = sprites.quads[tile_name]
      local _, _, qw, qh = quad:getViewport()
      -- g.draw(sprites.texture, quad, px, py, 0, w / qw, h / qh)
      batch:add(quad, px, py, 0, w / qw, h / qh)
    end
  end

  return batch
end

function Map:initialize(grid)
  Base.initialize(self)

  self.grid = grid
  applyNotCornerBit(self.grid)
  self.width, self.height = #self.grid[1], #self.grid

  local size = 20
  local w, h = push:getWidth() / self.width, push:getHeight() / self.height
  self.body = buildExtrusionPhysicsTerrain(game.world, grid, size, size / (w / h))
  self.spritebatch = buildSpriteBatch(self.grid, self.width, self.height)

  self.deadends = findDeadEnds(self.grid)
end

function Map:draw()
  local width, height = self.width, self.height

  g.push('all')
  g.setColor(255, 255, 255)
  g.draw(self.spritebatch)

  g.pop()
end

function Map:gridToPixel(x, y)
  local width, height = #self.grid[1], #self.grid
  local w, h = push:getWidth() / width, push:getHeight() / height
  return (x - 0.5) * w, (y - 0.5) * h
end

return Map
