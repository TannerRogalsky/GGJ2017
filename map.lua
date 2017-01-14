local Map = class('Map', Base)
local MAP_CONSTANTS = require('map.constants')
local N, S, E, W = unpack(MAP_CONSTANTS.DIRECTIONS)

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
}

local bitmask_alt = {
  [N + E] = 'tile_314',
  [N + W] = 'tile_315',
  [S + E] = 'tile_287',
  [S + W] = 'tile_288',
  [S + E + W] = 'tile_283',
  [N + E + W] = 'tile_284',
  [N + S + E] = 'tile_310',
  [N + S + W] = 'tile_311',
  [N + S + E + W] = 'tile_341',
}


local function buildPhysicsTerrain(world, grid)
  local body = love.physics.newBody(world, 0, 0, 'static')
  local newFixture = love.physics.newFixture
  local newEdge = love.physics.newEdgeShape

  local width, height = #grid[1], #grid
  local w, h = push:getWidth() / width, push:getHeight() / height
  local px, py
  for y=1,height do
    py = (y - 1) * h
    for x=1,width do
      px = (x - 1) * w
      if bit.band(grid[y][x], S) == 0 then
        local shape = newEdge(px, py + h, px + w, py + h)
        local fixture = newFixture(body, shape, 1)
      end
      if bit.band(grid[y][x], N) == 0 then
        local shape = newEdge(px, py, px + w, py)
        local fixture = newFixture(body, shape, 1)
      end
      if bit.band(grid[y][x], W) == 0 then
        local shape = newEdge(px, py, px, py + h)
        local fixture = newFixture(body, shape, 1)
      end
      if bit.band(grid[y][x], E) == 0 then
        local shape = newEdge(px + w, py, px + w, py + h)
        local fixture = newFixture(body, shape, 1)
      end
    end
  end

  return body
end

function Map:initialize(grid)
  Base.initialize(self)

  self.grid = grid
  self.body = buildPhysicsTerrain(game.world, grid)

  self.width, self.height = #self.grid[1], #self.grid
end

function Map:draw()
  local sprites = game.sprites
  local width, height = #self.grid[1], #self.grid

  g.push('all')
  g.setColor(255, 255, 255)
  local w, h = push:getWidth() / width, push:getHeight() / height
  local px, py
  for y=1,height do
    py = (y - 1) * h
    for x=1,width do
      px = (x - 1) * w

      local tile_name = bitmask[self.grid[y][x]]
      local quad = sprites.quads[tile_name]
      local _, _, qw, qh = quad:getViewport()
      g.draw(sprites.texture, quad, px, py, 0, w / qw, h / qh)
    end
  end

  -- -- blank out center squares
  -- for y=1,height-1 do
  --   for x=1,width-1 do
  --     if bit.band(self.grid[y][x], E) ~= 0 and
  --        bit.band(self.grid[y][x + 1], S) ~= 0 and
  --        bit.band(self.grid[y + 1][x + 1], W) ~= 0 and
  --        bit.band(self.grid[y + 1][x], N) ~= 0 then
  --       py = (y - 0.5) * h
  --       px = (x - 0.5) * w
  --       local quad = sprites.quads.tile_93
  --       local _, _, qw, qh = quad:getViewport()
  --       g.draw(sprites.texture, quad, px, py, 0, w / qw, h / qh)
  --     end
  --   end
  -- end
  g.pop()
end

function Map:gridToPixel(x, y)
  local width, height = #self.grid[1], #self.grid
  local w, h = push:getWidth() / width, push:getHeight() / height
  return (x - 0.5) * w, (y - 0.5) * h
end

return Map
