extern float time = 0;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  texture_coords -= 0.5;
  texture_coords *= 4.0;
  if (abs(texture_coords.x) > 1.0 || abs(texture_coords.y) > 1.0) {
    texture_coords /= 2.0;
    float c = dot(texture_coords, texture_coords);
    return vec4(color.rgb, 1.0 - c);
  } else {
    float c = dot(texture_coords, texture_coords);
    float n = 3.0;
    c = fract(c * (n - pow(sin(time), 2) * (n * 0.9)));
    vec3 ncolor = smoothstep(vec3(0.956, 0.682, 0.207), color.rgb, vec3(c, c, c));
    return vec4(ncolor, 1.0);
  }
}
#endif
