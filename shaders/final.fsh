#version 430 compatibility

out vec3 final_color;

in vec2 uv;

uniform sampler2D colortex0;
uniform sampler2D shadowtex0;

uniform float frameTimeCounter;

void main() {
	final_color = texture(colortex0, uv).rgb;

	if (uv.x < 0.0) {
		final_color = texture(shadowtex0, uv).rgb; // Must sample shadowtex0 so that shadow program runs
	}
}
