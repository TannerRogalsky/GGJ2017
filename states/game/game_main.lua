local Main = Game:addState('Main')

local function physicsDebugDraw()
  for _,body in ipairs(game.world:getBodyList()) do
    local x, y = body:getPosition()
    for _,fixture in ipairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      local shapeType = shape:getType()
      g.push()
      g.translate(x, y)
      if shapeType == 'circle' then
        local x, y = shape:getPoint()
        g.circle('fill', x, y, shape:getRadius())
      elseif shapeType == 'edge' then
        g.line(shape:getPoints())
      end
      g.pop()
    end
  end
end

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  self.world = love.physics.newWorld(0, 0)

  local width, height = math.floor(16 / 2), math.floor(9 / 2)
  local grid = growingTree(width, height, {random = 1, newest = 1}, love.math.random(math.pow(2, 53)))
  self.map = Map:new(grid)

  self.players = {
    Player:new()
  }

  self.sprites = require('images.sprites')

  g.setFont(self.preloaded_fonts["04b03_16"])
end

function Main:update(dt)
  self.world:update(dt)
  for i,player in ipairs(self.players) do
    player:update(dt)
  end
end

function Main:draw()
  push:start()
  self.camera:set()

  self.map:draw()

  physicsDebugDraw()

  for i,player in ipairs(self.players) do
    player:draw()
  end

  self.camera:unset()
  push:finish()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.world:destroy()
  self.camera = nil
end

return Main
