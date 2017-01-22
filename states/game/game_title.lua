local Title = Game:addState('Title')

function Title:enteredState()
end

function Title:draw()
  push:start()

  g.draw(game.preloaded_images['title.png'])

  push:finish()
end

function Title:keyreleased(key, scancode)
  self:gotoState('Menu')
end

function Title:gamepadreleased(joystick, button)
  self:gotoState('Menu')
end

function Title:exitedState()
end

return Title
