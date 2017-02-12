local fixtures
local num = 0

local function accumulate(fixture)
  table.insert(fixtures, fixture)
  num = num + 1
  return true
end

local function queryBBox(world, x1, y1, x2, y2)
  num = 0
  fixtures = {}
  world:queryBoundingBox(x1, y1, x2, y2, accumulate)
  return fixtures
end

return queryBBox
