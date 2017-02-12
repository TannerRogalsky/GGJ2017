local ray_hit = {x = 0, y = 0, xn = 0, yn = 0, fraction = 0}
local did_hit = false
local filter = nil

local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
  if filter and filter(fixture, x, y, xn, yn, fraction) then
    return -1
  end

  did_hit = true
  ray_hit.x = x
  ray_hit.y = y
  ray_hit.xn = xn
  ray_hit.yn = yn
  ray_hit.fraction = fraction

  return fraction
end

local function rayCastClosest(world, x1, y1, x2, y2, rayCastFilter)
  filter = rayCastFilter
  did_hit = false
  world:rayCast(x1, y1, x2, y2, worldRayCastCallback)
  if did_hit then
    return ray_hit
  else
    return nil
  end
end

return rayCastClosest
