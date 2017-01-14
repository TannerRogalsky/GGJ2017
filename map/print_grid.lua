local MAP_CONSTANTS = require('map.constants')
local N, S, E, W = unpack(MAP_CONSTANTS.DIRECTIONS)

local function printGrid(grid)
  local w = io.write
  local width, height = #grid[1], #grid
  print(width, height)
  w(" ")
  for i=1,width * 2 - 1 do w("_") end
  print("")
  for y=1,height do
    w("|")
    for x=1,width do

      if bit.band(grid[y][x], S) ~= 0 then
        w(" ")
      else
        w("_")
      end

      if bit.band(grid[y][x], E) ~= 0 then
        if bit.band(bit.bor(grid[y][x], grid[y][x+1]), S) ~= 0 then
          w(" ")
        else
          w("_")
        end
      else
        w("|")
      end
    end
    print("")
  end
end

return printGrid
