varying vec2 VaryingMaskCoord;

#define PI 3.1459

#ifdef VERTEX
attribute vec2 VertexMaskCoord;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
  VaryingMaskCoord = VertexMaskCoord;
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 st, vec2 screen_coords) {
  vec4 mask = Texel(texture, VaryingMaskCoord) * color;
  return Texel(texture, st) + mask;
}
#endif
