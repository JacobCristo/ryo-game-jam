shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float fisheye_intensity : hint_range(-1.0, 1.0) = 0.5;
uniform float zoom: hint_range(0.0, 4.0) = 1.1;

// DITHER CODE

uniform float vignette_radius: hint_range(0, 1) = 0.1;
uniform float edge: hint_range(0.0, 5.0) = 5.0;
uniform vec2 center = vec2(0.5);

float sd_circle(vec2 uv) {
	return length(uv - center) * 1.114;
}

vec4 bayer(int x, int y) {
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

	int bx = px.x % 4;
	int by = px.y % 4;
	float thresh = bayer(bx, by).r;
	vec3 dithered = vec3(lum < thresh ? 0.0 : 1.0);
	dithered *= sd_circle(uvP);

	float dist = length(uvP - center);
	float vig_alpha = smoothstep(vignette_radius - edge, vignette_radius + edge, dist);

	vec3 final_color = mix(color.rgb, dithered, vig_alpha);
	return vec4(final_color, 1.0);
}

// END DITHER

// NOISE CODE
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain

vec4 noise(vec4 original_color, vec2 uvP) {

    // Generate random noise
    float noise = (fract(sin(TIME * dot(uvP, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

    // Add noise to the original color
    original_color.rgb += noise * grain_amount * grain_size;

    // Clamp the final color to make sure it stays in the valid range
    return clamp(original_color, 0.0, 1.0);
}

// END NOISE


void fragment() {
	ivec2 px = ivec2(FRAGCOORD.xy);
	vec4 original_color = texture(screen_texture, SCREEN_UV);

	// Apply fisheye distortion to UVs FIRST
	vec2 uv = SCREEN_UV;
	uv = ((uv - 0.5) / zoom) + 0.5;
	vec2 p = uv * 2.0 - 1.0;
	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	p.x *= aspect;

	float r = length(p);
	float theta = atan(p.y, p.x);

	float factor = 1.0 + fisheye_intensity * r * r;
	float r_new = r * factor;

	vec2 p_distorted = vec2(cos(theta), sin(theta)) * r_new;
	p_distorted.x /= aspect;
	vec2 uv_dist = (p_distorted + 1.0) * 0.5;

	// Sample fisheye-corrected color
	vec4 color = texture(SCREEN_TEXTURE, uv_dist);
	color = noise(color, UV);

	// Apply dither + vignette on the fisheye result
	vec4 dither_pass = dither_effect(px, color, uv_dist);

	COLOR = dither_pass * 1.6;
}