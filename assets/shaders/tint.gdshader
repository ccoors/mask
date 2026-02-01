shader_type canvas_item;

uniform float inner_radius = 0.0;
uniform float outer_radius = 0.7;
uniform float vignette_strength = 0.2;
uniform vec4 vignette_color: source_color;

void fragment() {
	float dist = distance(UV, vec2(0.5));
	float vignette = smoothstep(inner_radius, outer_radius, dist) * vignette_strength;
    float dither = fract(sin(dot(UV, vec2(12.9898 * (TIME-float(int(TIME))), 78.233))) * 43758.5453123) * 0.5 * pow(dist * 2.0, 2.0);
	COLOR = vec4(vignette_color.rgb, vignette_color.a * vignette + dither);
}
