shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform float fisheye_intensity : hint_range(-1.0, 1.0) = 0.5;
uniform float zoom: hint_range(0.0, 4.0) = 1.1;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv = ((uv - vec2(0.5, 0.5)) / zoom) + vec2(0.5, 0.5);
	vec2 p = uv * 2.0 - 1.0;
	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	p.x *= aspect;
	// radial distance from center
	float r = length(p);
	float theta = atan(p.y, p.x);

	// fisheye distortion
	float factor = 1.0 + fisheye_intensity * r * r;
	float r_new = r * factor;
	
	vec2 p_distorted = vec2(cos(theta), sin(theta)) * r_new;
	p_distorted.x /= aspect;
	vec2 uv_dist = (p_distorted + 1.0) * 0.5;

	if (any(lessThan(uv_dist, vec2(0.0))) || any(greaterThan(uv_dist, vec2(1.0)))) {
	        // Outside the screen, use black (or any other background color)
	        COLOR = vec4(0.0);
	    } else {
	        // Sample the original screen texture at the distorted UV
	        COLOR = texture(SCREEN_TEXTURE, uv_dist);
	    }
	
}
