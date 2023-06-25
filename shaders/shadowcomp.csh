#version 430 compatibility
#include "/include/global.glsl"

layout (local_size_x = 32) in;
const ivec3 workGroups = ivec3(4, 128, 128);

writeonly uniform image3D floodfill_img;

uniform usampler3D voxel_sampler;
uniform sampler3D floodfill_sampler_copy;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

ivec3[6] face_offsets = ivec3[6](
	ivec3( 1,  0,  0),
	ivec3( 0,  1,  0),
	ivec3( 0,  0,  1),
	ivec3(-1,  0,  0),
	ivec3( 0, -1,  0),
	ivec3( 0,  0, -1)
);

#include "/include/blocklight_color.glsl"
#include "/include/blocklight_tint.glsl"
#include "/include/voxelization.glsl"

void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID);
	ivec3 previous_pos = ivec3(vec3(pos) - floor(previousCameraPosition) + floor(cameraPosition));

	vec3 light;

	uint voxel = texelFetch(voxel_sampler, pos, 0).x;

	if (voxel == 0 || voxel >= 200) {
		vec3 light_old = texelFetch(floodfill_sampler_copy, previous_pos, 0).rgb;
		vec3 light_px  = texelFetch(floodfill_sampler_copy, clamp(previous_pos + face_offsets[0], ivec3(0), voxel_volume_size - 1), 0).rgb;
		vec3 light_py  = texelFetch(floodfill_sampler_copy, clamp(previous_pos + face_offsets[1], ivec3(0), voxel_volume_size - 1), 0).rgb;
		vec3 light_pz  = texelFetch(floodfill_sampler_copy, clamp(previous_pos + face_offsets[2], ivec3(0), voxel_volume_size - 1), 0).rgb;
		vec3 light_nx  = texelFetch(floodfill_sampler_copy, clamp(previous_pos + face_offsets[3], ivec3(0), voxel_volume_size - 1), 0).rgb;
		vec3 light_ny  = texelFetch(floodfill_sampler_copy, clamp(previous_pos + face_offsets[4], ivec3(0), voxel_volume_size - 1), 0).rgb;
		vec3 light_nz  = texelFetch(floodfill_sampler_copy, clamp(previous_pos + face_offsets[5], ivec3(0), voxel_volume_size - 1), 0).rgb;

		light = (light_old + light_px + light_py + light_pz + light_nx + light_ny + light_nz) * rcp(7.0);

		if (voxel >= 200) {
			vec3 tint = blocklight_tint[min(voxel - 200u, blocklight_tint.length() - 1u)];
			light *= sqr(tint);
		}
	} else {
		vec3 color = blocklight_color[min(voxel, blocklight_color.length() - 1u)];
	    light = sqr(color);
	}

	imageStore(floodfill_img, pos, vec4(light, 0.0));
}
