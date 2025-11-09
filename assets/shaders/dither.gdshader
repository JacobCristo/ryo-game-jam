shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float viginette_radius: hint_range(0, 1) = 0.1;
uniform float edge: hint_range(0.0, 5.0) = 5.0;
uniform vec2 center = vec2(0.5);

float sd_circle(vec2 uv) {
	return length(uv - center) * 1.114;
}

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

vec4 dither_effect(ivec2 px, vec4 color, vec2 uvP) {
    float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // Bayer dithering
    int bx = px.x % 4;
    int by = px.y % 4;
    float thresh = bayer(bx, by).r;
    vec3 dithered = vec3(lum < thresh ? 0.0 : 1.0);
	dithered *= sd_circle(uvP);
    // Distance from center
    float dist = length(uvP - center);

    // Smooth vignette alpha: 1 inside radius-edge, 0 outside radius+edge
    float vig_alpha = smoothstep(viginette_radius - edge, viginette_radius + edge, dist);

    // Apply vignette effect multiplied by dithering
    vec3 fx = vec3(vig_alpha * dithered);
    vec3 no_fx = color.rgb;

    return vec4(dithered + no_fx, 1.0);
}

void fragment() {
	ivec2 px = ivec2(FRAGCOORD.xy);
	vec4 color = texture(SCREEN_TEXTURE, UV);
	vec4 dither_pass = dither_effect(px, color, UV);
	COLOR = dither_pass;

}
