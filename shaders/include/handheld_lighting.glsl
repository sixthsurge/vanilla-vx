#if !defined INCLUDE_HANDHELD_LIGHTING
#define INCLUDE_HANDHELD_LIGHTING

#include "/include/blocklight_color.glsl"

vec3 get_handheld_lighting(vec3 scene_pos, int held_item_id) {
	vec3 light_color = blocklight_color[clamp(held_item_id - 10001, 0, blocklight_color.length() - 1)];
	float falloff = rcp(dot(scene_pos, scene_pos) + 1.0);
	return light_color * falloff;
}

#endif // INCLUDE_HANDHELD_LIGHTING
