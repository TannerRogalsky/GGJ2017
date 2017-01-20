local getLineOfSightPoints = require('light.get_line_of_sight_points').fast
local hits = {}
local MAX_VERTS = 1000 -- I think it's actually closer to 500
for i=1,MAX_VERTS do hits[i] = {0, 0} end
local mesh = g.newMesh(MAX_VERTS, 'fan', 'stream')

local function buildLightOverlay(x, y)
  local num_hits = getLineOfSightPoints(hits, x, y)
  mesh:setVertices(hits)
  mesh:setDrawRange(1, num_hits)
  g.draw(mesh, x, y)
end

return buildLightOverlay
