local Points = Game:addState('Points')

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

  local det = (a[1]) * (b[2]) - (b[1]) * (a[2])
  if det < 0 then
    return true
  elseif det > 0 then
    return false
  end

  local d1 = (a[1]) * (a[1]) + (a[2]) * (a[2])
  local d2 = (b[1]) * (b[1]) + (b[2]) * (b[2])
  return d1 > d2
end

function Points:enteredState()
  center_x, center_y = push:getWidth() / 2, push:getHeight() / 2
  num_points = 20
  points = {{0, 0}}
  love.math.setRandomSeed(0)
  for i=1,num_points do
    table.insert(points, {love.math.random(300) - 150, love.math.random(300) - 150})
  end

  table.sort(points, getIsLess)
  print(unpack(points[1]))
  table.insert(points, {points[2][1], points[2][2]})

  mesh = g.newMesh(points, 'fan', 'static')
end

function Points:draw()
  -- local verts = {}
  -- for _,v in ipairs(points) do
  --   table.insert(verts, v[1])
  --   table.insert(verts, v[2])
  -- end
  -- g.setColor(255, 0, 0)
  -- g.polygon('fill', verts)
  g.setWireframe(love.keyboard.isDown('space'))
  g.draw(mesh, center_x, center_y)
  -- g.setWireframe(false)

  -- g.setColor(255, 255, 255)
  -- for i,point in ipairs(points) do
  --   g.li, point[1], point[2])
  --   g.print(i, point[1], point[2])
  -- end
end

function Points:exitedState()
end

return Points
