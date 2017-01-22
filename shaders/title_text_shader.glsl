extern float time = 0.0;
varying vec4 vpos;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  vpos = vertex_position;
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  // float c = fract(screen_coords.x / 100 + screen_coords.y * 0.01 + time * 0.3);
  float c = fract(screen_coords.y * 0.02 + time * 0.3);
  color.rgb = mix(vec3(1.0), vec3(217.0/255.0, 17.0/255.0, 197.0/255.0), c + 0.2);
  return Texel(texture, texture_coords) * color;
}
#endif
