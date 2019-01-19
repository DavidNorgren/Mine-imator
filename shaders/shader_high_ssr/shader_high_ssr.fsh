uniform vec2 uScreenSize;
uniform float uPower;

uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;
uniform mat4 uViewMatrix;
uniform mat4 uViewMatrixInv;

varying vec2 vTexCoord;

vec2 texelSize = 1.0 / uScreenSize;

void main()
{
	//gl_FragColor = vec4(vTexCoord, 1.0, 1.0);
	
	if (vTexCoord.x > 0.5)
		gl_FragColor = texture2D(uDepthBuffer, vTexCoord);
	else
		gl_FragColor = texture2D(uNormalBuffer, vTexCoord);
}
