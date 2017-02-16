local function carefulSet(bad_cells, x, y)
  if bad_cells[x] == nil then bad_cells[x] = {} end
  bad_cells[x][y] = true
end

local function carefulGet(bad_cells, x, y)
  if bad_cells[x] then return bad_cells[x][y] end
  return false
end

local function getGridPos(x, y)
  return x / push:getWidth() * game.map.width, y / push:getHeight() * game.map.height
end

local function getGridSpotsForPoint(bad_cells, px, py, w, h)
  local x, y = getGridPos(px, py)
  carefulSet(bad_cells, math.floor(x), math.floor(y))
  carefulSet(bad_cells, math.floor(x), math.ceil(y))
  carefulSet(bad_cells, math.ceil(x), math.ceil(y))
  carefulSet(bad_cells, math.ceil(x), math.floor(y))
end

local function get_next_spawn_point(game)
  local width, height = game.map.width, game.map.height

  local bad_cells = {}
  for _,player in ipairs(game.players) do
    for _,attacker in ipairs(player.attackers) do
      getGridSpotsForPoint(bad_cells, attacker.x, attacker.y, width, height)
    end

    for _,defender in ipairs(player.defenders) do
      getGridSpotsForPoint(bad_cells, defender.x, defender.y, width, height)
    end
  end

  for _,powerup in ipairs(game.powerups) do
    getGridSpotsForPoint(bad_cells, powerup.x, powerup.y, width, height)
  end

  local x = math.ceil(game.random:random(1, width))
  local y = math.ceil(game.random:random(1, height))
  while carefulGet(bad_cells, x, y) do
    x = math.ceil(game.random:random(1, width))
    y = math.ceil(game.random:random(1, height))
  end

  return x, y
end

return get_next_spawn_point
