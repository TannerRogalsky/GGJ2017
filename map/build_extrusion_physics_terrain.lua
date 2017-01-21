local MAP_CONSTANTS = require('map.constants')
local N, S, E, W = unpack(MAP_CONSTANTS.DIRECTIONS)

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

local function buildExtrusionPhysicsTerrain(world, grid, size_x, size_y)
  local body = love.physics.newBody(world, 0, 0, 'static')
  local newFixture = love.physics.newFixture
  local newRectangleShape = love.physics.newRectangleShape

  local width, height = #grid[1], #grid
  local w, h = push:getWidth() / width, push:getHeight() / height
  local px, py
  for y=1,height do
    py = (y - 1) * h
    for x=1,width do
      px = (x - 1) * w
      if bit.band(grid[y][x], S) == 0 then
        local ew, eh = w, size_y
        local shape = newRectangleShape(px + ew / 2, py + eh / 2 + h - size_y, ew + size_x * 2, eh)
        local fixture = newFixture(body, shape, 1)
        if y == height then
          fixture:setCategory(1)
        else
          fixture:setCategory(2)
        end
      end
      if bit.band(grid[y][x], N) == 0 then
        local ew, eh = w, size_y
        local shape = newRectangleShape(px + ew / 2, py + eh / 2, ew + size_x * 2, eh)
        local fixture = newFixture(body, shape, 1)
        if y == 1 then
          fixture:setCategory(1)
        else
          fixture:setCategory(2)
        end
      end
      if bit.band(grid[y][x], W) == 0 then
        local ew, eh = size_x, h
        local shape = newRectangleShape(px + ew / 2, py + eh / 2, ew, eh + size_y * 2)
        local fixture = newFixture(body, shape, 1)
        if x == 1 then
          fixture:setCategory(1)
        else
          fixture:setCategory(2)
        end
      end
      if bit.band(grid[y][x], E) == 0 then
        local ew, eh = size_x, h
        local shape = newRectangleShape(px + ew / 2 + w - size_x, py + eh / 2, ew, eh + size_y * 2)
        local fixture = newFixture(body, shape, 1)
        if x == width then
          fixture:setCategory(1)
        else
          fixture:setCategory(2)
        end
      end
    end
  end

  return body
end

return buildExtrusionPhysicsTerrain
