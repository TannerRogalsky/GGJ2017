local PowerupSpawner = class('PowerupSpawner', Base)
local NEXT_T_MIN, NEXT_T_MAX = 5, 20 -- time til next spawn
local NEXT_N_MIN, NEXT_N_MAX = 0, 3 -- number powerups spawned

local MAX_POWERUPS = 10

local getNextSpawnPoint = require('get_next_spawn_point')
local NewAttackerPowerup = require('powerups.new_attacker_powerup')
local HealPowerup = require('powerups.heal_powerup')

local powerup_types = {
  NewAttackerPowerup,
  HealPowerup,
}

local function spawn(self)
  for i=0,love.math.random(NEXT_N_MIN, NEXT_N_MAX)-1 do
    if #game.powerups >= MAX_POWERUPS then break end

    local x, y = game.map:gridToPixel(getNextSpawnPoint(game))
    local Type = powerup_types[love.math.random(#powerup_types)]
    table.insert(game.powerups, Type:new(x, y))
  end

  self.timer = cron.after(love.math.random(NEXT_T_MIN, NEXT_T_MAX), spawn, self)
end

function PowerupSpawner:initialize()
  Base.initialize(self)

  spawn(self)
end

function PowerupSpawner:update(dt)
  self.timer:update(dt)
end

return PowerupSpawner
