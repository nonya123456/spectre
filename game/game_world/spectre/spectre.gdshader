shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D emission_texture : source_color;

uniform vec4 emission_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float emission_strength : hint_range(0.0, 10.0, 0.01) = 1.0;

uniform float shake_power = 0.005;
uniform float shake_rate : hint_range(0.0, 1.0) = 0;
uniform float shake_speed = 5.0;

float random(float seed) {
	return fract(sin(seed * 12345.678) * 43758.5453);
}

void vertex() {
	float adjusted_time = mod(TIME, 5.0);
	float enable_shift = float(random(trunc(adjusted_time * shake_speed)) < shake_rate);
	float offset_x = (random((trunc(VERTEX.y * 30.0) / 30.0) + adjusted_time) - 0.5) * shake_power * enable_shift;
	VERTEX.x += offset_x;
}

void fragment() {
	vec4 base_color_data = texture(albedo_texture, UV);
	ALBEDO = base_color_data.rgb;
	ALPHA = base_color_data.a;

	vec4 emissive_data = texture(emission_texture, UV);
	EMISSION = emissive_data.rgb * emissive_data.a * emission_color.rgb * emission_strength;
}
