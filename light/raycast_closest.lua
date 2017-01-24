local ray_hit = {x = 0, y = 0}
local did_hit = false

local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
  if fixture:isSensor() then return -1 end

  did_hit = true
  ray_hit.x = x
  ray_hit.y = y

  return fraction
end

local function rayCastClosest(world, x1, y1, x2, y2)
  did_hit = false
  world:rayCast(x1, y1, x2, y2, worldRayCastCallback)
  if did_hit then
    return ray_hit
  else
    return nil
  end
end

return rayCastClosest
