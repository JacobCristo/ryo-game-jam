shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

vec4 bayer(int x, int y) {
	// bayer kernel
    float[16] bayer = float[16](
        0.0/16.0,  8.0/16.0,  2.0/16.0, 10.0/16.0,
        12.0/16.0, 4.0/16.0, 14.0/16.0, 6.0/16.0,
        3.0/16.0, 11.0/16.0, 1.0/16.0, 9.0/16.0,
        15.0/16.0, 7.0/16.0, 13.0/16.0, 5.0/16.0
    );
	int index = x + (4 * y);
	return vec4(bayer[index]);
}

void fragment() {
	ivec2 px = ivec2(FRAGCOORD.xy);
	vec4 color = texture(SCREEN_TEXTURE, UV);
	float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
	
	// use bayer matrix
	int bx = px.x % 4;
	int by = px.y % 4;
	float thresh = bayer(bx, by).r;
	float dithered = lum < thresh ? 0.0 : 1.0;
	COLOR = vec4(vec3(dithered), 1.0);
}
