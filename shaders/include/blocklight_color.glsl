#ifndef INCLUDE_BLOCKLIGHT_COLOR
#define INCLUDE_BLOCKLIGHT_COLOR

const vec3[] blocklight_color = vec3[](
	// Air
	vec3(0.0),
	// Non-emissive blocks
	vec3(0.0),
	// Dim white
	vec3(1.00, 1.00, 1.00) * 2.0,
	// Medium white
	vec3(1.00, 1.00, 1.00) * 4.0,
	// Bright white
	vec3(1.00, 1.00, 1.00) * 6.0,
	// Dim gold
	vec3(1.00, 0.45, 0.25) * 2.0,
	// Medium gold
	vec3(1.00, 0.45, 0.25) * 4.0,
	// Bright gold
	vec3(1.00, 0.45, 0.25) * 6.0,
	// Dim red
	vec3(1.00, 0.10, 0.10) * 2.0,
	// Medium red
	vec3(1.00, 0.10, 0.10) * 4.0,
	// Bright red
	vec3(1.00, 0.10, 0.10) * 8.0,
	// Dim orange
	vec3(1.00, 0.10, 0.10) * 2.0,
	// Medium orange
	vec3(1.00, 0.11, 0.00) * 4.0,
	// Bright orange
	vec3(1.00, 0.11, 0.00) * 12.0,
	// Yellow
	vec3(1.00, 0.45, 0.00) * 2.0,
	// Soul lights
	vec3(0.25, 0.75, 1.00) * 3.0,
	// Nether portal
	vec3(0.5, 0.0, 1.00) * 8.0,
	// Verdant froglight
	vec3(0.75, 1.0, 0.30) * 4.0,
	// Pearlescent froglight
	vec3(0.75, 0.30, 1.00) * 4.0,
	// Buffer
	vec3(0.0)
);

#endif // INCLUDE_BLOCKLIGHT_COLOR
