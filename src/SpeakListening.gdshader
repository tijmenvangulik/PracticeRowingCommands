shader_type canvas_item;

// rings rippling outwards from the speak button while listening

uniform vec4 ring_color : hint_color = vec4(0.2, 0.92, 0.71, 1.0);
uniform float speed = 0.6;
uniform float inner_radius = 0.42;
uniform float ring_width = 0.08;

void fragment() {
	float d = length(UV * 2.0 - 1.0);
	float a = 0.0;
	for (int i = 0; i < 3; i++) {
		float t = fract(TIME * speed + float(i) / 3.0);
		float r = mix(inner_radius, 1.0, t);
		float ring = 1.0 - smoothstep(0.0, ring_width, abs(d - r));
		a = max(a, ring * (1.0 - t));
	}
	float glow = 1.0 - smoothstep(inner_radius, inner_radius + 0.15, d);
	a = max(a, glow * (0.35 + 0.15 * sin(TIME * 4.0)));
	COLOR = vec4(ring_color.rgb, ring_color.a * a);
}
