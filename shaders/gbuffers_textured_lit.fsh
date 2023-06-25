#version 430 compatibility
#include "/include/global.glsl"

layout (location = 0) out vec4 frag_color;

/* DRAWBUFFERS:0 */

in vec2 uv;
in vec2 lightmap_uv;
in vec4 tint;

in vec3 normal;
in vec3 voxel_pos;

uniform sampler3D floodfill_sampler;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform vec3 cameraPosition;

#include "/include/utility/color.glsl"
#include "/include/voxelization.glsl"

const float shadowDistanceRenderMul = 1.0;

void main() {
	vec4 base_color = texture(gtexture, uv) * tint;
	if (base_color.a < 0.1) discard;

	vec3 rgb = base_color.rgb * texture(lightmap, lightmap_uv).rgb;
	     rgb = srgb_eotf_inv(rgb);

	vec3 albedo = srgb_eotf_inv(base_color.rgb);

	if (is_inside_voxel_volume(voxel_pos)) {
		vec3 voxel_sample_pos = clamp01((voxel_pos + normal * 0.5) * rcp(vec3(voxel_volume_size)));
		vec3 floodfill_light = texture(floodfill_sampler, voxel_sample_pos).rgb;

		rgb += sqrt(floodfill_light) * albedo;
	}

	rgb *= inversesqrt(rgb * rgb + 1.0);
	rgb  = srgb_eotf(rgb);

	frag_color = vec4(rgb, base_color.a);
}
