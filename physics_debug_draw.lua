local function physicsDebugDraw()
  g.push('all')
  for _,body in ipairs(game.world:getBodyList()) do
    if body:isActive() then
      local x, y = body:getPosition()
      g.push()
      g.translate(x, y)
      g.rotate(body:getAngle())
      g.setColor(255, 255, 255)
      for _,fixture in ipairs(body:getFixtureList()) do
        local shape = fixture:getShape()
        local shapeType = shape:getType()
        if shapeType == 'circle' then
          local x, y = shape:getPoint()
          local radius = shape:getRadius()
          g.circle('line', x, y, radius)
          g.line(x, y, x + radius, y)
        elseif shapeType == 'edge' then
          g.line(shape:getPoints())
        elseif shapeType == 'polygon' then
          g.polygon('line', shape:getPoints())
        elseif shapeType == 'chain' then
          g.line(shape:getPoints())
        end
      end
      g.pop()

      g.setColor(0, 0, 255)
      for _,joint in ipairs(body:getJointList()) do
        local x1, y1, x2, y2 = joint:getAnchors()
        g.circle('fill', x1, y1, 3)
        g.circle('fill', x2, y2, 3)
      end
    end
  end
  g.pop()
end

return physicsDebugDraw
