shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float zoom_factor: hint_range(1.0, 10.0, 0.1) = 1.0;
uniform float shake_intensity: hint_range(0.0, 0.05, 0.001) = 0;

void fragment() {
	vec2 shake_offset = vec2(
		sin(TIME * 20.0) * shake_intensity,
		cos(TIME * 20.0) * shake_intensity
	);

	vec2 shaken_uv = UV + shake_offset;
	COLOR = texture(TEXTURE, center + (shaken_uv - center) / zoom_factor);
}
