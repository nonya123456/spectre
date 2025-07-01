shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D emission_texture : source_color;

uniform vec4 emission_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float emission_strength : hint_range(0.0, 10.0, 0.01) = 1.0;

void fragment() {
    vec4 base_color_data = texture(albedo_texture, UV);
    ALBEDO = base_color_data.rgb;

    vec4 emissive_data = texture(emission_texture, UV);
    EMISSION = emissive_data.rgb * emissive_data.a * emission_color.rgb * emission_strength;
}
