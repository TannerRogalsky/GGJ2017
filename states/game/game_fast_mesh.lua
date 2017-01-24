local FastMesh = Game:addState('FastMesh')

local num_verts = 100000

local ffi = require('ffi')
ffi.cdef[[
typedef struct {
  float x, y;
  float s, t;
  unsigned char r, g, b, a;
} fm_vertex;
]]
local vertex_size = ffi.sizeof('fm_vertex')
local pixel_size = ffi.sizeof('unsigned char[4]')
local imageData = love.image.newImageData(num_verts / pixel_size * vertex_size, 1)
local data = ffi.cast("fm_vertex*", imageData:getPointer())

function FastMesh:enteredState()
  self.mesh = g.newMesh(num_verts, 'fan', 'stream')

  for i=0,num_verts-1 do
    local vertex = data[i]
    vertex.r = 255
    vertex.g = 255
    vertex.b = 255
    vertex.a = 255
  end
end

local t = 0
function FastMesh:update(dt)
  t = t + dt
  local radius = 300
  for i=1,num_verts do
    local vertex = data[i - 1]
    local phi = (i - 1) / num_verts * math.pi * 2
    vertex.x = math.cos(phi) * radius + math.cos(t + phi) * radius / 4
    vertex.y = math.sin(phi) * radius
  end
  self.mesh:setVertices(imageData)
end

function FastMesh:draw()
  -- g.setWireframe(love.keyboard.isDown('space'))
  g.draw(self.mesh, g.getWidth() / 2, g.getHeight() / 2)
end

function FastMesh:keypressed()
end

function FastMesh:exitedState()
end

return FastMesh
