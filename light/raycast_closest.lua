local ray_hits = {}
local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
  table.insert(ray_hits, {
    object = fixture:getUserData(),
    x = x,
    y = y,
    xn = xn,
    yn = yn,
    fraction = fraction
  })
  return 1
end

local function rayCast(world, x1, y1, x2, y2, callback)
  ray_hits = {}
  world:rayCast(x1, y1, x2, y2, worldRayCastCallback)
  return ray_hits
end

local function rayCastClosest(world, x1, y1, x2, y2, callback)
  rayCast(world, x1, y1, x2, y2, callback)
  if #ray_hits > 0 then
    local closest_hit = ray_hits[1]
    for i,hit in ipairs(ray_hits) do
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
