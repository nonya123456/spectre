shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float force: hint_range(1.0, 10.0, 0.1) = 1.0;

void fragment() {
	COLOR = texture(TEXTURE, center + (UV - center) / force);
}
