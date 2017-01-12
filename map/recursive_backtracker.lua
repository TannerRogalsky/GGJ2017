local CONSTANTS = require('map.constants')
local N, S, E, W = unpack(CONSTANTS.DIRECTIONS)
local DX         = CONSTANTS.DX
local DY         = CONSTANTS.DY
local OPPOSITE   = CONSTANTS.OPPOSITE

local function shuffle(t, r)
  local n = #t -- gets the length of the table
  while n >= 2 do -- only run if the table has more than 1 element
    local k = r:random(n) -- get a random number
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
  return t
end

local function carve_passages_from(cx, cy, grid, r)
  local directions = shuffle({N, S, E, W}, r)

  for _,direction in ipairs(directions) do
    local nx, ny = cx + DX[direction], cy + DY[direction]

    if (0 < ny and ny <= #grid) and (0 < nx and nx <= #grid[ny]) and grid[ny][nx] == 0 then
      grid[cy][cx] = bit.bor(grid[cy][cx], direction)
      grid[ny][nx] = bit.bor(grid[ny][nx], OPPOSITE[direction])
      carve_passages_from(nx, ny, grid, r)
     end
  end
end

local function generate(width, height, seed)
  local grid = {}
  for y=1,height do
    grid[y] = {}
    for x=1,width do
      grid[y][x] = 0
    end
  end

  local r = love.math.newRandomGenerator(seed or 0)
  carve_passages_from(1, 1, grid, r)
  return grid
end

return generate
