extern float time = 0;
#define NUM_COLORS 2
extern vec3 gradient_colors[NUM_COLORS];

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
    return vec4(gradient_colors[0], 1.0 - c);
  } else {
    float c = dot(texture_coords, texture_coords);
    float n = 3.0;
    c = fract(c * (n - pow(sin(time), 2) * (n * 0.9)));

    float stepIncrement = 1.0 / float(NUM_COLORS);
    float step = 0.0;
    vec3 mixed = mix(gradient_colors[0], gradient_colors[1], c);
    // vec3 mixed = gradient_colors[0];
    // for (int i = 1; i < NUM_COLORS; ++i) {
    //   mixed = mix(mixed, gradient_colors[i], smoothstep(step, step + stepIncrement, c)); step += stepIncrement;
    // }

    return vec4(mixed, 1.0);
  }
}
#endif
