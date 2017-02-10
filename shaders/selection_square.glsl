#define PI 3.14159265359
#define TWO_PI 6.28318530718

extern float time;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
  return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 st, vec2 screen_coords) {
  float t = time / 10;

  // Remap the space to -1. to 1.
  vec2 tc = st * 2.0 - 1.0;

  // Number of sides of your shape
  int N = 4;

  // Angle and radius from the current pixel
  float a = atan(tc.x,tc.y)+PI;
  float r = TWO_PI/float(N);

  // Shaping function that modulate the distance
  float d = cos(floor(.5+a/r)*r-a)*length(tc);

  vec3 c = vec3(1.0 - step(0.1, mod(d + t, 0.2)));

  return Texel(texture, st) * vec4(c, 1.0) * color;
}
#endif
