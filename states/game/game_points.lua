local Points = Game:addState('Points')
local ffi = require('ffi')
ffi.cdef[[
typedef struct {
  float x, y;
  float s, t;
  unsigned char r, g, b, a;
} fm_vertex;
]]

local incs = { 1391376,
               463792, 198768, 86961, 33936,
               13776, 4592, 1968, 861, 336,
               112, 48, 21, 7, 3, 1 }
local temp = ffi.new('fm_vertex')
local struct_size = ffi.sizeof('fm_vertex')
local function shellsort(t, n, before)
  for _, h in ipairs(incs) do
    for i = h, n - 1 do
      ffi.copy(temp, t[i], struct_size)
      for j = i - h, 0, -h do
        local testval = t[j]
        if not before(temp, testval) then break end
        t[i] = testval; i = j
      end
      t[i] = temp
    end
  end
  return t
end

local function getIsLess(a, b)
  if a.x == 0 and a.y == 0 then
    return true
  elseif b.x == 0 and b.y == 0 then
    return false
  end
  if a.x >= 0 and b.x < 0 then return true end
  if a.x < 0 and b.x >= 0 then return false end
  if a.x == 0 and b.x == 0 then
    if a.y >= 0 or b.y >= 0 then return a.y > b.y end
    return b.y > a.y
  end

  local det = (a.x) * (b.y) - (b.x) * (a.y)
  if det < 0 then
    return true
  elseif det > 0 then
    return false
  end

  local d1 = (a.x) * (a.x) + (a.y) * (a.y)
  local d2 = (b.x) * (b.x) + (b.y) * (b.y)
  return d1 > d2
end

local num_verts = 20
local vertex_size = ffi.sizeof('fm_vertex')
local pixel_size = ffi.sizeof('unsigned char[4]')
local imageData = love.image.newImageData(num_verts / pixel_size * vertex_size, 1)
local data = ffi.cast("fm_vertex*", imageData:getPointer())

function Points:enteredState()
  love.math.setRandomSeed(0)
  center_x, center_y = push:getWidth() / 2, push:getHeight() / 2

  for i=0,num_verts-1 do
    local vertex = data[i]
    vertex.r = 255;
    vertex.g = 255;
    vertex.b = 255;
    vertex.a = 255;
  end

  data[0].x, data[0].y = 0, 0
  for i=1,num_verts-2 do
    data[i].x = love.math.random(300) - 150
    data[i].y = love.math.random(300) - 150
  end
  shellsort(data, num_verts - 1, getIsLess)
  data[num_verts - 1].x, data[num_verts - 1].y = data[1].x, data[1].y

  -- for i=0, num_verts-1 do
  --   print(data[i].x, data[i].y)
  -- end

  mesh = g.newMesh(num_verts, 'fan', 'static')
  mesh:setVertices(imageData)
end

function Points:draw()
  g.setWireframe(love.keyboard.isDown('space'))
  g.draw(mesh, center_x, center_y)
end

function Points:exitedState()
end

return Points
