#version 430 compatibility
#include "/include/global.glsl"

out vec2 uv;
out vec2 lightmap_uv;
out vec4 tint;

out vec3 normal;
out vec3 voxel_pos;

attribute vec4 at_tangent;

uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

#include "/include/voxelization.glsl"

void main() {
	uv   = gl_MultiTexCoord0.xy;
	tint = gl_Color;

	normal = mat3(gbufferModelViewInverse) * normalize(gl_NormalMatrix * gl_Normal);

	vec3 view_pos  = transform(gl_ModelViewMatrix, gl_Vertex.xyz);
	vec3 scene_pos = transform(gbufferModelViewInverse, view_pos);

	voxel_pos = scene_to_voxel_space(scene_pos);
	vec4 tc = gl_MultiTexCoord1 * vec4(float(!is_inside_voxel_volume(voxel_pos)), vec3(1.0));
	lightmap_uv = (gl_TextureMatrix[1] * tc).xy;

	gl_Position = project(gl_ProjectionMatrix, view_pos);
}
