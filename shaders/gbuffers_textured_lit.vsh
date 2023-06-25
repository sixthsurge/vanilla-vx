#version 430 compatibility
#include "/include/global.glsl"

out vec2 uv;
out vec2 lightmap_uv;
out vec2 lightmap_uv_no_blocklight;
out vec4 tint;

out vec3 normal;
out vec3 scene_pos;

attribute vec4 at_tangent;

uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

void main() {
	uv                        = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lightmap_uv               = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	lightmap_uv_no_blocklight = (gl_TextureMatrix[1] * vec4(0.0, gl_MultiTexCoord1.yzw)).xy;
	tint                      = gl_Color;

	normal = mat3(gbufferModelViewInverse) * normalize(gl_NormalMatrix * gl_Normal);

	vec3 view_pos = transform(gl_ModelViewMatrix, gl_Vertex.xyz);
	scene_pos     = transform(gbufferModelViewInverse, view_pos);

	gl_Position = project(gl_ProjectionMatrix, view_pos);
}
