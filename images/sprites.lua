-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:e4dd263da1565839f6a0627614e7a1e5:1ef61905b9a58d11eb44f088af955e46:ce59e0ef6b4af9fefc088af809f682f1$
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

Quads["player_1_body"] = love.graphics.newQuad(861, 275, 31, 24, 924, 396 )
Quads["player_1_life"] = love.graphics.newQuad(793, 275, 32, 32, 924, 396 )
Quads["player_1_life_ring"] = love.graphics.newQuad(793, 309, 32, 32, 924, 396 )
Quads["player_1_sword"] = love.graphics.newQuad(793, 265, 53, 8, 924, 396 )
Quads["player_2_body"] = love.graphics.newQuad(861, 301, 31, 24, 924, 396 )
Quads["player_2_life"] = love.graphics.newQuad(793, 343, 32, 32, 924, 396 )
Quads["player_2_life_ring"] = love.graphics.newQuad(827, 275, 32, 32, 924, 396 )
Quads["player_2_sword"] = love.graphics.newQuad(848, 265, 53, 8, 924, 396 )
Quads["powerup_attack"] = love.graphics.newQuad(894, 306, 27, 28, 924, 396 )
Quads["powerup_health"] = love.graphics.newQuad(894, 275, 28, 29, 924, 396 )
Quads["tile_280"] = love.graphics.newQuad(1, 1, 64, 64, 924, 396 )
Quads["tile_280_mask"] = love.graphics.newQuad(1, 67, 64, 64, 924, 396 )
Quads["tile_281"] = love.graphics.newQuad(1, 133, 64, 64, 924, 396 )
Quads["tile_281_mask"] = love.graphics.newQuad(1, 199, 64, 64, 924, 396 )
Quads["tile_282"] = love.graphics.newQuad(1, 265, 64, 64, 924, 396 )
Quads["tile_282_mask"] = love.graphics.newQuad(1, 331, 64, 64, 924, 396 )
Quads["tile_283"] = love.graphics.newQuad(67, 1, 64, 64, 924, 396 )
Quads["tile_283_mask"] = love.graphics.newQuad(67, 67, 64, 64, 924, 396 )
Quads["tile_284"] = love.graphics.newQuad(67, 133, 64, 64, 924, 396 )
Quads["tile_284_mask"] = love.graphics.newQuad(67, 199, 64, 64, 924, 396 )
Quads["tile_285"] = love.graphics.newQuad(67, 265, 64, 64, 924, 396 )
Quads["tile_285_mask"] = love.graphics.newQuad(67, 331, 64, 64, 924, 396 )
Quads["tile_286"] = love.graphics.newQuad(133, 1, 64, 64, 924, 396 )
Quads["tile_286_mask"] = love.graphics.newQuad(133, 67, 64, 64, 924, 396 )
Quads["tile_287"] = love.graphics.newQuad(133, 133, 64, 64, 924, 396 )
Quads["tile_287_mask"] = love.graphics.newQuad(133, 199, 64, 64, 924, 396 )
Quads["tile_288"] = love.graphics.newQuad(133, 265, 64, 64, 924, 396 )
Quads["tile_288_mask"] = love.graphics.newQuad(133, 331, 64, 64, 924, 396 )
Quads["tile_307"] = love.graphics.newQuad(199, 1, 64, 64, 924, 396 )
Quads["tile_307_mask"] = love.graphics.newQuad(199, 67, 64, 64, 924, 396 )
Quads["tile_308"] = love.graphics.newQuad(199, 133, 64, 64, 924, 396 )
Quads["tile_308_mask"] = love.graphics.newQuad(199, 199, 64, 64, 924, 396 )
Quads["tile_309"] = love.graphics.newQuad(199, 265, 64, 64, 924, 396 )
Quads["tile_309_mask"] = love.graphics.newQuad(199, 331, 64, 64, 924, 396 )
Quads["tile_310"] = love.graphics.newQuad(265, 1, 64, 64, 924, 396 )
Quads["tile_310_mask"] = love.graphics.newQuad(265, 67, 64, 64, 924, 396 )
Quads["tile_311"] = love.graphics.newQuad(265, 133, 64, 64, 924, 396 )
Quads["tile_311_mask"] = love.graphics.newQuad(265, 199, 64, 64, 924, 396 )
Quads["tile_312"] = love.graphics.newQuad(265, 265, 64, 64, 924, 396 )
Quads["tile_312_mask"] = love.graphics.newQuad(265, 331, 64, 64, 924, 396 )
Quads["tile_313"] = love.graphics.newQuad(331, 1, 64, 64, 924, 396 )
Quads["tile_313_mask"] = love.graphics.newQuad(331, 67, 64, 64, 924, 396 )
Quads["tile_314"] = love.graphics.newQuad(331, 133, 64, 64, 924, 396 )
Quads["tile_314_mask"] = love.graphics.newQuad(331, 199, 64, 64, 924, 396 )
Quads["tile_315"] = love.graphics.newQuad(331, 265, 64, 64, 924, 396 )
Quads["tile_315_mask"] = love.graphics.newQuad(331, 331, 64, 64, 924, 396 )
Quads["tile_334"] = love.graphics.newQuad(397, 1, 64, 64, 924, 396 )
Quads["tile_334_mask"] = love.graphics.newQuad(397, 67, 64, 64, 924, 396 )
Quads["tile_335"] = love.graphics.newQuad(397, 133, 64, 64, 924, 396 )
Quads["tile_335_mask"] = love.graphics.newQuad(397, 199, 64, 64, 924, 396 )
Quads["tile_336"] = love.graphics.newQuad(397, 265, 64, 64, 924, 396 )
Quads["tile_336_mask"] = love.graphics.newQuad(397, 331, 64, 64, 924, 396 )
Quads["tile_337"] = love.graphics.newQuad(463, 1, 64, 64, 924, 396 )
Quads["tile_337_mask"] = love.graphics.newQuad(463, 67, 64, 64, 924, 396 )
Quads["tile_338"] = love.graphics.newQuad(463, 133, 64, 64, 924, 396 )
Quads["tile_338_mask"] = love.graphics.newQuad(463, 199, 64, 64, 924, 396 )
Quads["tile_339"] = love.graphics.newQuad(463, 265, 64, 64, 924, 396 )
Quads["tile_339_mask"] = love.graphics.newQuad(463, 331, 64, 64, 924, 396 )
Quads["tile_340"] = love.graphics.newQuad(529, 1, 64, 64, 924, 396 )
Quads["tile_340_mask"] = love.graphics.newQuad(529, 67, 64, 64, 924, 396 )
Quads["tile_341"] = love.graphics.newQuad(529, 133, 64, 64, 924, 396 )
Quads["tile_341_mask"] = love.graphics.newQuad(529, 199, 64, 64, 924, 396 )
Quads["tile_361"] = love.graphics.newQuad(529, 265, 64, 64, 924, 396 )
Quads["tile_361_mask"] = love.graphics.newQuad(529, 331, 64, 64, 924, 396 )
Quads["tile_362"] = love.graphics.newQuad(595, 1, 64, 64, 924, 396 )
Quads["tile_362_mask"] = love.graphics.newQuad(661, 1, 64, 64, 924, 396 )
Quads["tile_363"] = love.graphics.newQuad(727, 1, 64, 64, 924, 396 )
Quads["tile_363_mask"] = love.graphics.newQuad(793, 1, 64, 64, 924, 396 )
Quads["tile_364"] = love.graphics.newQuad(859, 1, 64, 64, 924, 396 )
Quads["tile_364_mask"] = love.graphics.newQuad(595, 67, 64, 64, 924, 396 )
Quads["tile_365"] = love.graphics.newQuad(595, 133, 64, 64, 924, 396 )
Quads["tile_365_mask"] = love.graphics.newQuad(595, 199, 64, 64, 924, 396 )
Quads["tile_366"] = love.graphics.newQuad(595, 265, 64, 64, 924, 396 )
Quads["tile_366_mask"] = love.graphics.newQuad(595, 331, 64, 64, 924, 396 )
Quads["tile_390"] = love.graphics.newQuad(661, 67, 64, 64, 924, 396 )
Quads["tile_390_mask"] = love.graphics.newQuad(727, 67, 64, 64, 924, 396 )
Quads["tile_391"] = love.graphics.newQuad(793, 67, 64, 64, 924, 396 )
Quads["tile_391_mask"] = love.graphics.newQuad(859, 67, 64, 64, 924, 396 )
Quads["tile_392"] = love.graphics.newQuad(661, 133, 64, 64, 924, 396 )
Quads["tile_392_mask"] = love.graphics.newQuad(661, 199, 64, 64, 924, 396 )
Quads["tile_393"] = love.graphics.newQuad(661, 265, 64, 64, 924, 396 )
Quads["tile_393_mask"] = love.graphics.newQuad(661, 331, 64, 64, 924, 396 )
Quads["tile_417"] = love.graphics.newQuad(727, 133, 64, 64, 924, 396 )
Quads["tile_417_mask"] = love.graphics.newQuad(793, 133, 64, 64, 924, 396 )
Quads["tile_418"] = love.graphics.newQuad(859, 133, 64, 64, 924, 396 )
Quads["tile_418_mask"] = love.graphics.newQuad(727, 199, 64, 64, 924, 396 )
Quads["tile_419"] = love.graphics.newQuad(727, 265, 64, 64, 924, 396 )
Quads["tile_419_mask"] = love.graphics.newQuad(727, 331, 64, 64, 924, 396 )
Quads["tile_420"] = love.graphics.newQuad(793, 199, 64, 64, 924, 396 )
Quads["tile_420_mask"] = love.graphics.newQuad(859, 199, 64, 64, 924, 396 )

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
