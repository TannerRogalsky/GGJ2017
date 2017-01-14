local function getUVs(textureAtlas, quadName)
  local quad = textureAtlas.quads[quadName]
  local texture = textureAtlas.texture
  local x, y, w, h = quad:getViewport()
  local iw, ih = texture:getDimensions()
  local ua, va = x / iw, y / ih
  local ub, vb = (x + w) / iw, (y + h) / ih
  return ua, va, ub, vb
end

return getUVs
