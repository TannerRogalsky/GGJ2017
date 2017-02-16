extern float falloff_distance = 200;
varying vec4 vpos;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  vpos = vertex_position;
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  color.a = 1.0 - length(vpos.xy) / falloff_distance;
  return color;
}
#endif
