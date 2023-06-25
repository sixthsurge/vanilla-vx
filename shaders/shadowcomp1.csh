#version 430 compatibility

#include "/include/global.glsl"

layout (local_size_x = 32) in;
const ivec3 workGroups = ivec3(4, 128, 128);

writeonly uniform image3D floodfill_img_copy;

uniform sampler3D floodfill_sampler;

void main() {
	ivec3 pos = ivec3(gl_GlobalInvocationID);
	vec4 light = texelFetch(floodfill_sampler, pos, 0);
	imageStore(floodfill_img_copy, pos, light);
}
