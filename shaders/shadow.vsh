#version 430 compatibility

#include "/include/global.glsl"

attribute vec4 mc_Entity;
attribute vec3 at_midBlock;

writeonly uniform uimage3D voxel_img;

uniform mat4 shadowModelViewInverse;
uniform vec3 cameraPosition;

uniform int renderStage;

#define PROGRAM_SHADOW
#include "/include/voxelization.glsl"

void main() {
	uint block_id = uint(max0(mc_Entity.x - 10000.0));
	update_voxel_map(block_id);
	gl_Position = vec4(-1.0);
}
