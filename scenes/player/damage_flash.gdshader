shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0, 0.1);
uniform vec4 dash_color : source_color;
uniform float dash_value : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);

	vec4 new_color = mix(texture_color, dash_color, dash_value);

	COLOR = mix(new_color, flash_color, flash_value);
	COLOR.a = texture_color.a;
}