local ray_hits = {}
local num_hits = 0

-- Private constructor.
local function new(x, y, fraction)
  return setmetatable({
    x = x,
    y = y,
    fraction = fraction
  })
end

-- Do the check to see if JIT is enabled. If so use the optimized FFI structs.
local status, ffi
if type(jit) == "table" and jit.status() then
  status, ffi = pcall(require, "ffi")
  if status then
    ffi.cdef "typedef struct { double x, y, fraction; } ray_hit;"
    new = ffi.typeof("ray_hit")
  end
end

local function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
  num_hits = num_hits + 1
  ray_hits[num_hits] = new(x, y, fraction)
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
