in vec2 fragCoord;
out vec4 fragColor;

uniform float bars[512];
uniform int bars_count;
uniform vec3 u_resolution;
uniform vec3 bg_color;
uniform vec3 fg_color;

float normalize_C(float x, float x_min, float x_max, float r_min, float r_max) {
    return (r_max - r_min) * (x - x_min) / (x_max - x_min) + r_min;
}

void main() {
    int bar = int(bars_count * fragCoord.x);
    float x = normalize_C(fragCoord.y, 1.0, 0.0, 0.0, bars[bar]);

    fragColor.r = fg_color.x * x;
    fragColor.g = fg_color.y * x;
    fragColor.b = fg_color.z * x;
    fragColor.a = 1.0;
}
