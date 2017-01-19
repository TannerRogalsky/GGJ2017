local ray_hits = {}
for i=1,1000 do
  ray_hits[i] = {x = 0, y = 0, fraction = 0}
end
local num_hits = 0

local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
  if fixture:isSensor() then return 1 end

  num_hits = num_hits + 1
  ray_hits[num_hits].x = x
  ray_hits[num_hits].y = y
  ray_hits[num_hits].fraction = fraction
  return 1
end

local function rayCastClosest(world, x1, y1, x2, y2)
  num_hits = 0
  world:rayCast(x1, y1, x2, y2, worldRayCastCallback)
  if num_hits > 0 then
    local closest_hit = ray_hits[1]
    for i=1,num_hits do
      local hit = ray_hits[i]
      if hit.fraction < closest_hit.fraction then
        closest_hit = hit
      end
    end

    return closest_hit
  else
    return nil
  end
end

return rayCastClosest
