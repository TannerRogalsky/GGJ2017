-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:e32d5cf3e4b5ecb7f40ce11897d997cd:09cb16b7f74ffe374e89651ffc89efd3:ce59e0ef6b4af9fefc088af809f682f1$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("sprites")
	batch = love.graphics.newSpriteBatch( myAtlas.texture, 100, "stream" )
end
function love.draw()
	batch:clear()
	batch:bind()
		batch:add( myAtlas.quads['mySpriteName'], love.mouse.getX(), love.mouse.getY() )
	batch:unbind()
	love.graphics.draw(batch)
end

--]]------------------------------------------------------------------------

local TextureAtlas = {}
local Quads = {}
local Texture = game.preloaded_images["sprites.png"]

Quads["player_1_body"] = love.graphics.newQuad(925, 1, 31, 24, 957, 198 )
Quads["player_1_life"] = love.graphics.newQuad(913, 67, 32, 32, 957, 198 )
Quads["player_1_life_ring"] = love.graphics.newQuad(913, 101, 32, 32, 957, 198 )
Quads["player_1_sword"] = love.graphics.newQuad(893, 169, 53, 8, 957, 198 )
Quads["player_2_body"] = love.graphics.newQuad(925, 27, 31, 24, 957, 198 )
Quads["player_2_life"] = love.graphics.newQuad(910, 135, 32, 32, 957, 198 )
Quads["player_2_life_ring"] = love.graphics.newQuad(859, 157, 32, 32, 957, 198 )
Quads["player_2_sword"] = love.graphics.newQuad(893, 179, 53, 8, 957, 198 )
Quads["robot1_gun"] = love.graphics.newQuad(859, 112, 49, 43, 957, 198 )
Quads["soldier1_gun"] = love.graphics.newQuad(859, 67, 52, 43, 957, 198 )
Quads["tile_280"] = love.graphics.newQuad(1, 1, 64, 64, 957, 198 )
Quads["tile_281"] = love.graphics.newQuad(1, 67, 64, 64, 957, 198 )
Quads["tile_282"] = love.graphics.newQuad(1, 133, 64, 64, 957, 198 )
Quads["tile_283"] = love.graphics.newQuad(67, 1, 64, 64, 957, 198 )
Quads["tile_284"] = love.graphics.newQuad(67, 67, 64, 64, 957, 198 )
Quads["tile_285"] = love.graphics.newQuad(67, 133, 64, 64, 957, 198 )
Quads["tile_286"] = love.graphics.newQuad(133, 1, 64, 64, 957, 198 )
Quads["tile_287"] = love.graphics.newQuad(133, 67, 64, 64, 957, 198 )
Quads["tile_288"] = love.graphics.newQuad(133, 133, 64, 64, 957, 198 )
Quads["tile_307"] = love.graphics.newQuad(199, 1, 64, 64, 957, 198 )
Quads["tile_308"] = love.graphics.newQuad(199, 67, 64, 64, 957, 198 )
Quads["tile_309"] = love.graphics.newQuad(199, 133, 64, 64, 957, 198 )
Quads["tile_310"] = love.graphics.newQuad(265, 1, 64, 64, 957, 198 )
Quads["tile_311"] = love.graphics.newQuad(265, 67, 64, 64, 957, 198 )
Quads["tile_312"] = love.graphics.newQuad(265, 133, 64, 64, 957, 198 )
Quads["tile_313"] = love.graphics.newQuad(331, 1, 64, 64, 957, 198 )
Quads["tile_314"] = love.graphics.newQuad(331, 67, 64, 64, 957, 198 )
Quads["tile_315"] = love.graphics.newQuad(331, 133, 64, 64, 957, 198 )
Quads["tile_334"] = love.graphics.newQuad(397, 1, 64, 64, 957, 198 )
Quads["tile_335"] = love.graphics.newQuad(397, 67, 64, 64, 957, 198 )
Quads["tile_336"] = love.graphics.newQuad(397, 133, 64, 64, 957, 198 )
Quads["tile_337"] = love.graphics.newQuad(463, 1, 64, 64, 957, 198 )
Quads["tile_338"] = love.graphics.newQuad(463, 67, 64, 64, 957, 198 )
Quads["tile_339"] = love.graphics.newQuad(463, 133, 64, 64, 957, 198 )
Quads["tile_340"] = love.graphics.newQuad(529, 1, 64, 64, 957, 198 )
Quads["tile_341"] = love.graphics.newQuad(529, 67, 64, 64, 957, 198 )
Quads["tile_361"] = love.graphics.newQuad(529, 133, 64, 64, 957, 198 )
Quads["tile_362"] = love.graphics.newQuad(595, 1, 64, 64, 957, 198 )
Quads["tile_363"] = love.graphics.newQuad(595, 67, 64, 64, 957, 198 )
Quads["tile_364"] = love.graphics.newQuad(595, 133, 64, 64, 957, 198 )
Quads["tile_365"] = love.graphics.newQuad(661, 1, 64, 64, 957, 198 )
Quads["tile_366"] = love.graphics.newQuad(661, 67, 64, 64, 957, 198 )
Quads["tile_390"] = love.graphics.newQuad(661, 133, 64, 64, 957, 198 )
Quads["tile_391"] = love.graphics.newQuad(727, 1, 64, 64, 957, 198 )
Quads["tile_392"] = love.graphics.newQuad(727, 67, 64, 64, 957, 198 )
Quads["tile_393"] = love.graphics.newQuad(727, 133, 64, 64, 957, 198 )
Quads["tile_417"] = love.graphics.newQuad(793, 1, 64, 64, 957, 198 )
Quads["tile_418"] = love.graphics.newQuad(859, 1, 64, 64, 957, 198 )
Quads["tile_419"] = love.graphics.newQuad(793, 67, 64, 64, 957, 198 )
Quads["tile_420"] = love.graphics.newQuad(793, 133, 64, 64, 957, 198 )

function TextureAtlas:getDimensions(quadName)
	local quad = self.quads[quadName]
	if not quad then
		return nil
	end
	local x, y, w, h = quad:getViewport()
    return w, h
end

TextureAtlas.quads = Quads
TextureAtlas.texture = Texture

return TextureAtlas
