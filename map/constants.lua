local N, S, E, W = 1, 2, 4, 8
local DX         = { [E] = 1, [W] = -1, [N] =  0, [S] = 0 }
local DY         = { [E] = 0, [W] =  0, [N] = -1, [S] = 1 }
local OPPOSITE   = { [E] = W, [W] =  E, [N] =  S, [S] = N }

return {
  DIRECTIONS = {N, S, E, W},
  DX = DX,
  DY = DY,
  OPPOSITE = OPPOSITE,
}
