local CONSTANTS  = require('map.constants')
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

local function generate(width, height, modes, seed)
  local r = love.math.newRandomGenerator(seed or 0)
  local grid = {}
  for y=1,height do
    grid[y] = {}
    for x=1,width do
      grid[y][x] = 0
    end
  end

  local selectors = {
    random = function(ceil) return r:random(ceil) end,
    newest = function(ceil) return ceil end,
    middle = function(ceil) return ceil / 2 end,
    oldest = function(ceil) return 1 end,
  }

  local total_weight = 0
  local parts = {}
  for name,weight in pairs(modes) do
    total_weight = total_weight + weight
    table.insert(parts, {
      name = name,
      weight = total_weight
    })
  end
  local function next_index(ceil)
    local v = r:random(total_weight)
    for _,part in ipairs(parts) do
      if v <= part.weight then
        return selectors[part.name](ceil)
      end
    end

    error('failed to find command of weight: ' .. v)
  end

  local cells = {}
  local x, y = r:random(width), r:random(height)
  table.insert(cells, {x, y})

  while #cells > 0 do
    local index = next_index(#cells)
    local x, y = cells[index][1], cells[index][2]

    for _,dir in ipairs(shuffle({N, S, E, W}, r)) do
      local nx, ny = x + DX[dir], y + DY[dir]
      if nx > 0 and ny > 0 and nx <= width and ny <= height and grid[ny][nx] == 0 then
        grid[y][x] = bit.bor(grid[y][x], dir)
        grid[ny][nx] = bit.bor(grid[ny][nx], OPPOSITE[dir])
        table.insert(cells, {nx, ny})
        index = nil
        break
      end
    end

    if index ~= nil then
      table.remove(cells, index)
    end
  end

  return grid
end

return generate
