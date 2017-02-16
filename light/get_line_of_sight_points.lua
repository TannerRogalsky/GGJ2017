local queryBBox = require('light.query_bbox')
local rayCastClosest = require('light.raycast_closest')
local shellsort = require('light.shellsort')
local num_hits = 0

local function rotate(phi, x,y, ox,oy)
  x, y = x - ox, y - oy
  local c, s = math.cos(phi), math.sin(phi)
  return c*x - s*y + ox,  s*x + c*y + oy
end

local function getIsLess(a, b)
  if a[1] == 0 and a[2] == 0 then
    return true
  elseif b[1] == 0 and b[2] == 0 then
    return false
  end
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

local function addHitFast(hits, x, y)
  num_hits = num_hits + 1
  hits[num_hits][1], hits[num_hits][2] = x, y
end

local function addHitSlow(hits, x, y)
  table.insert(hits, {x, y})
end

local function rotateAndCast(world, addHit, hits, filter, x1, y1, x2, y2, phi)
  x2, y2 = rotate(phi, x2, y2, x1, y1)
  local hit = rayCastClosest(world, x1, y1, x2, y2, filter)
  if hit then addHit(hits, hit.x - x1, hit.y - y1) end
  return hit
end

local function rayCast(world, addHit, hits, filter, x1, y1, body, x2, y2, ...)
  if x2 and y2 then
    x2, y2 = body:getWorldPoint(x2, y2)

    local dx = x2 - x1
    local dy = y2 - y1
    -- TODO might be possible to optimize the length here
    local x4 = x2 + (dx) * 100
    local y4 = y2 + (dy) * 100

    rotateAndCast(world, addHit, hits, filter, x1, y1, x4, y4, 0)
    rotateAndCast(world, addHit, hits, filter, x1, y1, x4, y4, 0.0001)
    rotateAndCast(world, addHit, hits, filter, x1, y1, x4, y4, -0.0001)

    rayCast(world, addHit, hits, filter, x1, y1, body, ...)
  end
end

local function getLineOfSightPoints(hits, x, y, filter)
  local world = game.world
  local body = game.map.body
  num_hits = 1
  hits[1][1], hits[1][2] = 0, 0
  local bx1, by1 = x - LIGHT_FALLOFF_DISTANCE, y - LIGHT_FALLOFF_DISTANCE
  local bx2, by2 = x + LIGHT_FALLOFF_DISTANCE, y + LIGHT_FALLOFF_DISTANCE
  for i,fixture in ipairs(queryBBox(world, bx1, by1, bx2, by2)) do
    local shape = fixture:getShape()
    if shape.getPoints then
      rayCast(world, addHitFast, hits, filter, x, y, fixture:getBody(), shape:getPoints())
    end
  end
  shellsort(hits, getIsLess, num_hits)
  num_hits = num_hits + 1
  hits[num_hits][1], hits[num_hits][2] = hits[2][1], hits[2][2]
  return num_hits
end

local function getLineOfSightPointsSlow(x, y)
  local world = game.world
  local body = game.map.body
  local hits = {}
  local bx1, by1 = x - LIGHT_FALLOFF_DISTANCE, y - LIGHT_FALLOFF_DISTANCE
  local bx2, by2 = x + LIGHT_FALLOFF_DISTANCE, y + LIGHT_FALLOFF_DISTANCE
  for i,fixture in ipairs(queryBBox(world, bx1, by1, bx2, by2)) do
    local shape = fixture:getShape()
    rayCast(world, addHitSlow, hits, filter, x, y, fixture:getBody(), shape:getPoints())
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
