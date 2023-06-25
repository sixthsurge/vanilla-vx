#version 430 compatibility
#include "/include/global.glsl"

layout (location = 0) out vec4 frag_color;

/* DRAWBUFFERS:0 */

in vec2 uv;
in vec2 lightmap_uv;
in vec2 lightmap_uv_no_blocklight;
in vec4 tint;

in vec3 normal;
in vec3 scene_pos;

uniform sampler3D floodfill_sampler;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform vec3 cameraPosition;

uniform int heldItemId;
uniform int heldItemId2;

#include "/include/utility/color.glsl"
#include "/include/handheld_lighting.glsl"
#include "/include/voxelization.glsl"

const float shadowDistanceRenderMul = 1.0;

void main() {
	vec3 voxel_pos = scene_to_voxel_space(scene_pos);

	// Ease transition to vanilla lighting
	float distance_fade  = max_of(abs(scene_pos));
	      distance_fade *= rcp(0.5 * voxel_volume_size.x);
		  distance_fade  = linear_step(0.75, 1.0, distance_fade);

	vec4 base_color = texture(gtexture, uv) * tint;
	if (base_color.a < 0.1) discard;

	vec2 lightmap_sample_uv = mix(lightmap_uv_no_blocklight, lightmap_uv, distance_fade);

	vec3 rgb = base_color.rgb * texture(lightmap, lightmap_sample_uv).rgb;
	     rgb = srgb_eotf_inv(rgb); // Convert to linear after applying vanilla lightmap

	vec3 albedo = srgb_eotf_inv(base_color.rgb);

	if (is_inside_voxel_volume(voxel_pos)) {
		vec3 voxel_sample_pos = clamp01((voxel_pos + normal * 0.5) * rcp(vec3(voxel_volume_size)));

		vec3 lighting  = sqrt(texture(floodfill_sampler, voxel_sample_pos).rgb);
		     lighting += get_handheld_lighting(scene_pos, heldItemId);
		     lighting += get_handheld_lighting(scene_pos, heldItemId2);

		rgb += lighting * albedo * (1.0 - distance_fade);
	}

	rgb *= inversesqrt(rgb * rgb + 1.0); // Tonemap
	rgb  = srgb_eotf(rgb); // Return to sRGB

	frag_color = vec4(rgb, base_color.a);
}
