extern float time = 0;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  texture_coords -= 0.5;
  texture_coords *= 2.0;
  float c = dot(texture_coords, texture_coords);
  c = fract(c * (21 + pow(sin(time * 3.14), 2) * 2));
  vec3 ncolor = smoothstep(vec3(244.0 / 255.0, 174.0 / 255.0, 53.0 / 255.0), color.rgb, vec3(c, c, c));
  return vec4(ncolor, 1.0);
}
#endif
