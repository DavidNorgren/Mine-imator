uniform vec2 uScreenSize;
uniform float uPower;

uniform sampler2D uColorBuffer;
uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;

uniform float uNear;
uniform float uFar;

varying vec2 vTexCoord;

const int maxf = 6;				// Max number of refinements
const float stp = 1.2;			// Size of one step in ray marching
const float ref = 0.07;			// Refinement multiplier
const float inc = 2.2;			// Increasement factor for each ray step

float unpackDepth(vec4 c)
{
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}

vec3 unpackNormal(vec4 c)
{
    return c.rgb * 2.0 - 1.0;
}

// Transform linear depth to exponential depth
float transformDepth(float depth)
{
	return (uFar - (uNear * uFar) / (depth * (uFar - uNear) + uNear)) / (uFar - uNear);
}

float getDepth(vec2 coords) {
	return transformDepth(unpackDepth(texture2D(uDepthBuffer, coords)));
}

vec3 CalcViewPositionFromDepth(in vec2 TexCoord)
{
    // Combine UV & depth into XY & Z (NDC)
    vec3 rawPosition                = vec3(TexCoord, getDepth(TexCoord));
	
    // Convert from (0, 1) range to (-1, 1)
    vec4 ScreenSpacePosition        = vec4(rawPosition.xyz * 2.0 - 1.0, 1.0);
	
    // Undo Perspective transformation to bring into view space
    vec4 ViewPosition               = uProjMatrixInv * ScreenSpacePosition;

    // Perform perspective divide and return
    return                          ViewPosition.xyz / ViewPosition.w;
}

vec2 RayCast(vec3 dir, inout vec3 startPos)
{	
	vec3 stepVector = dir;
	vec3 tVector = stepVector;
	
	vec3 curCoord = startPos + stepVector;
	vec3 prevCoord = curCoord;
	
	int refinements = 0;
	
    for (int i = 0; i < 25; i++) {
		vec4 projPos = uProjMatrix * vec4(curCoord, 1.0);
        projPos.xyz /= projPos.w;
        projPos.xyz = projPos.xyz * 0.5 + 0.5;
		
		if (projPos.x < 0.0 || projPos.x > 1.0 || projPos.y < 0.0 || projPos.y > 1.0 || projPos.z < 0.0 || projPos.z > 1.0)
			break;
		
        vec3 screenPos = CalcViewPositionFromDepth(projPos.xy);
		
		float err = distance(startPos, screenPos);
		
		if (err < pow(length(stepVector) * 1.85, 1.15))
		{
			refinements++;
			
			if (refinements >= maxf)
				return projPos.xy;
			
			tVector -= stepVector;
            stepVector *= ref;
		}
		
		stepVector *= inc;
		prevCoord = curCoord;
		tVector += stepVector;
		curCoord = startPos + tVector;
    }
	
    return vec2(-1.0);
}

void main()
{
	vec3 viewNormal = unpackNormal(texture2D(uNormalBuffer, vTexCoord));
	viewNormal.z = -viewNormal.z;
	
	vec3 viewPos = CalcViewPositionFromDepth(vTexCoord);
	vec3 reflected = normalize(reflect(viewPos, viewNormal));
	
	vec3 startPos = viewPos;
	
	vec3 dir;
	dir = reflected;
	
	vec2 coords = RayCast(dir, startPos);
	
	vec4 ssr = texture2D(uColorBuffer, vTexCoord);
	
	if (coords.x > -1.0)
		ssr = (ssr + texture2D(uColorBuffer, coords.xy)) * 0.5;
	
	gl_FragColor = ssr;// *0.0001 + vec4(reflected, 1.0);
}