local CONSTANTS  = require('map.constants')
local N, S, E, W = unpack(CONSTANTS.DIRECTIONS)
local DX         = CONSTANTS.DX
local DY         = CONSTANTS.DY
local OPPOSITE   = CONSTANTS.OPPOSITE

local possible_orientations = {
  horizontal = true,
  vertical = true,
  both = true
}

local swaps = {
  horizontal = {
    [E] = W,
    [E + N] = W + N,
    [E + S] = W + S,
    [E + N + S] = W + N + S,
    [W] = E,
    [W + N] = E + N,
    [W + S] = E + S,
    [W + N + S] = E + N + S,
  },
  vertical = {
    [N] = S,
    [N + E] = S + E,
    [N + W] = S + W,
    [N + E + W] = S + E + W,
    [S] = N,
    [S + E] = N + E,
    [S + W] = N + W,
    [S + E + W] = N + E + W,
  }
}

function toBits(num,bits)
  -- returns a table of bits, most significant first.
  bits = bits or select(2,math.frexp(num))
  local t={} -- will contain the bits
  for b=bits,1,-1 do
      t[b]=math.fmod(num,2)
      num=(num-t[b])/2
  end
  return table.concat(t, '')
end

local function symmetricalize(grid, orientation)
  assert(possible_orientations[orientation])
  local ow, oh = #grid[1], #grid

  local w, h = ow, oh
  if orientation == 'horizontal' then
    w = w * 2
  elseif orientation == 'vertical' then
    h = h * 2
  elseif orientation == 'both' then
    w = w * 2
    h = h * 2
  end

  local new_grid = {}
  for y=1,h do
    new_grid[y] = {}
    for x=1,w do
      if x <= ow and y <= oh then
        new_grid[y][x] = grid[y][x]
      else
        if x > ow and y <= oh then
          local mirrored_cell = grid[y][w - x + 1]
          new_grid[y][x] = swaps.horizontal[mirrored_cell] or mirrored_cell
        elseif y > oh and x <= ow then
          local mirrored_cell = grid[h - y + 1][x]
          new_grid[y][x] = swaps.vertical[mirrored_cell] or mirrored_cell
        else
          local mirrored_cell = grid[h - y + 1][w - x + 1]
          local intermediate = swaps.vertical[mirrored_cell] or mirrored_cell
          new_grid[y][x] = swaps.horizontal[intermediate] or intermediate
        end
      end
    end
  end

  if orientation == 'horizontal' or orientation == 'both' then
    local x = ow
    for y=1,h do
      new_grid[y][x] = bit.bor(new_grid[y][x], E)
      new_grid[y][x + 1] = bit.bor(new_grid[y][x + 1], W)
    end
  end
  if orientation == 'vertical' or orientation == 'both' then
    local y = oh
    for x=1,w do
      new_grid[y][x] = bit.bor(new_grid[y][x], S)
      new_grid[y+ 1][x] = bit.bor(new_grid[y+ 1][x], N)
    end
  end

  return new_grid
end

return symmetricalize
