local getLineOfSightPoints = require('light.get_line_of_sight_points').fast

local mesh = g.newMesh(10000, 'fan', 'stream') -- 1000 is some arbitrarily large number

local function buildLightOverlay(x, y)
  local hits = getLineOfSightPoints(x, y)
  mesh:setVertices(hits)
  mesh:setDrawRange(1, #hits)
  g.draw(mesh, x, y)
end

return buildLightOverlay
