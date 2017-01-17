local rayCastClosest = require('light.raycast_closest')

local function len(x, y)
  return x * x + y * y
end

local function rotate(phi, x,y, ox,oy)
  x, y = x - ox, y - oy
  local c, s = math.cos(phi), math.sin(phi)
  local nx, ny = c*x - s*y, s*x + c*y
  return nx + x, ny + y
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

local function rayCastToPoint(hits, world, x1, y1, x2, y2, ...)
  if x2 and y2 then
    local hit = rayCastClosest(world, x1, y1, x2, y2)
    if hit then
      table.insert(hits, {hit.x - x1, hit.y - y1})
    end
    rayCastToPoint(hits, world, x1, y1, ...)
  end
end

local function getLineOfSightPoints(x1, y1)
  -- local MAX_DIST = 200
  local world = game.world
  local body = game.map.body
  local hits = {}
  for _,fixture in ipairs(body:getFixtureList()) do
    local shape = fixture:getShape()
    rayCastToPoint(hits, world, x1, y1, shape:getPoints())
  end
  table.sort(hits, getIsLess)
  table.insert(hits, {hits[1][1], hits[1][2]})
  table.insert(hits, 1, {0, 0})
  return hits
end

local function rayCastToPointSlow(hits, world, x1, y1, x2, y2, ...)
  if x2 and y2 then
    local hit = rayCastClosest(world, x1, y1, x2, y2)
    if hit then
      table.insert(hits, {hit.x - x1, hit.y - y1})

      -- expensive. comment out if necessary
      local x3, y3 = rotate(0.001, x2, y2, x1, y1)
      hit = rayCastClosest(world, x1, y1, x3, y3)
      if hit then table.insert(hits, {hit.x - x1, hit.y - y1}) end
      x3, y3 = rotate(-0.001, x2, y2, x1, y1)
      hit = rayCastClosest(world, x1, y1, x3, y3)
      if hit then table.insert(hits, {hit.x - x1, hit.y - y1}) end
    end
    rayCastToPointSlow(hits, world, x1, y1, ...)
  end
end

local function getLineOfSightPointsSlow(x1, y1)
  -- local MAX_DIST = 200
  local world = game.world
  local body = game.map.body
  local hits = {}
  for _,fixture in ipairs(body:getFixtureList()) do
    local shape = fixture:getShape()
    rayCastToPointSlow(hits, world, x1, y1, shape:getPoints())
  end
  table.sort(hits, getIsLess)
  table.insert(hits, {hits[1][1], hits[1][2]})
  table.insert(hits, 1, {0, 0})
  return hits
end

return {
  fast = getLineOfSightPoints,
  slow = getLineOfSightPointsSlow
}
