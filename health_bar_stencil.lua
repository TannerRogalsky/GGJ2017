local function healthBarStencil()
  for i,player in ipairs(game.players) do
    for _,defender in ipairs(player.defenders) do
      local radius = defender.radius
      local health_ratio = defender.health / defender.max_health
      g.arc('fill', defender.x, defender.y, radius * 2, -math.pi / 2, health_ratio * math.pi * 2 - math.pi / 2, radius * 2)
    end
  end
end

return healthBarStencil
