local Character = require('player.character')
local DefenseCharacter = class('DefenseCharacter', Character)

function DefenseCharacter:initialize(x, y, radius, rotation)
  Character.initialize(self, x, y, radius, rotation)
end

return DefenseCharacter
