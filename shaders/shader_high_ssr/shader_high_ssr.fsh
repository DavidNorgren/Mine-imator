#define MAXSTEPS 200
#define MAXREFINESTEPS 30
#define SAMPLES 16

uniform sampler2D uColorBuffer;
uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;
uniform sampler2D uNoiseBuffer;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;
uniform mat4 uViewMatrixInv;

varying vec2 vTexCoord;

uniform float uNear;
uniform float uFar;
uniform vec2 uScreenSize;
uniform vec3 uKernel[SAMPLES];

float uStepSize = 5.0;
int uStepAmount = 50;
int uRefineSteps = 15;
uniform float uBlurStrength;

float unpackDepth(vec4 c) {
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}

vec3 unpackNormal(vec4 c) {
    return c.rgb * 2.0 - 1.0;
}

float transformDepth(float depth) {
    return (uFar - (uNear * uFar) / (depth * (uFar - uNear) + uNear)) / (uFar - uNear);
}

float getDepth(vec2 coords) {
	return unpackDepth(texture2D(uDepthBuffer, coords));
}

// Reconstruct a position from a screen space coordinate and (linear) depth
vec3 posFromBuffer(vec2 coord, float depth) {
    vec4 pos = uProjMatrixInv * vec4(coord.x * 2.0 - 1.0, 1.0 - coord.y * 2.0, transformDepth(depth), 1.0);
    return pos.xyz / pos.w;
}

vec2 BinarySearch(vec3 dir, inout vec3 hitCoord, out float dDepth) {
    vec3 screenPos;
	int steps = 0;
	
    for (int i = 0; i < MAXREFINESTEPS; i++) {
        vec4 projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
        projectedCoord.xy /= projectedCoord.w;
        projectedCoord.xy = projectedCoord.xy * 0.5 + 0.5;
		projectedCoord.y = 1.0 - projectedCoord.y;
		
		screenPos = posFromBuffer(projectedCoord.xy, getDepth(projectedCoord.xy));
		
        dDepth = screenPos.z - hitCoord.z;
		
		dir *= 0.5;
        if (dDepth > 0.0)
            hitCoord += dir;
		else
			hitCoord -= dir;
		
		steps++;
		
		if (steps > uRefineSteps)
			break;
    }
	
    vec4 projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
    projectedCoord.xy /= projectedCoord.w;
    projectedCoord.xy = projectedCoord.xy * 0.5 + 0.5;
	projectedCoord.y = 1.0 - projectedCoord.y;
	
	dDepth = 0.0;
    return vec2(projectedCoord.xy);
}

vec2 RayCast(vec3 dir, inout vec3 hitCoord, out float dDepth) {
    dir *= uStepSize;
	
	vec3 startPos = hitCoord;
	vec3 screenPos = vec3(hitCoord);
	int steps = 0;
	vec4 projectedCoord;
	vec2 screenCoord = vec2(0.0);
	
    for (int i = 0; i < MAXSTEPS; i++) {
        hitCoord += dir;

        projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
        screenCoord = (projectedCoord.xy / projectedCoord.w) * 0.5 + 0.5;
		screenCoord.y = 1.0 - screenCoord.y;
		
		screenPos = posFromBuffer(screenCoord, getDepth(screenCoord));
		
		if (screenCoord.x < 0.0 || screenCoord.x > 1.0 || screenCoord.y < 0.0 || screenCoord.y > 1.0)
			break;
		
        dDepth = screenPos.z - hitCoord.z;
		
		if (startPos.z < screenPos.z) {
			if (dDepth <= 0.0 && dDepth > (uStepSize * -2.0))
				return BinarySearch(dir, hitCoord, dDepth);
		}
		
		if (steps > uStepAmount)
		{
			dDepth = 1.0;
			break;
		}
		
		steps++;
    }
	
	dDepth = 1.0;
    return screenCoord;
}

float fresnelSchlick(float cosTheta, float F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main()
{
	float depth = getDepth(vTexCoord);
	vec3 viewNormal = normalize(unpackNormal(texture2D(uNormalBuffer, vTexCoord)));
	
	vec3 viewPos = posFromBuffer(vTexCoord, depth);
	vec3 reflected = normalize(reflect(normalize(viewPos), viewNormal));
	
	vec3 hitPos = viewPos;
	float dDepth;
	
	vec4 ssr = texture2D(uColorBuffer, vTexCoord);
	
	// Only do reflections on visible surfaces
	if (texture2D(uDepthBuffer, vTexCoord).a > 0.0)
	{
		vec3 reflectColor = vec3(0.0);
		float weightAmount = 0.0;
		
		// Random vector from noise
		vec2 noiseScale = (uScreenSize / 4.0);
		vec3 randVec = unpackNormal(texture2D(uNoiseBuffer, vTexCoord * noiseScale));
		
		// Construct kernel basis matrix
		vec3 tangent = normalize(randVec - viewNormal * dot(randVec, viewNormal));
		vec3 bitangent = cross(viewNormal, tangent);
		mat3 kernelBasis = mat3(tangent, bitangent, viewNormal);
		
		// Cast rays and get reflected color
		for (int i = 0; i < 6; i++)
		{
			vec3 offset = mix(vec3(0.0), kernelBasis * uKernel[i], uBlurStrength);
			vec2 coords = RayCast(offset + reflected * max(1.0, -viewPos.z), hitPos, dDepth);
			
			if (dDepth <= 0.0)
			{
				reflectColor += texture2D(uColorBuffer, coords.xy).rgb;
				weightAmount += 1.0;
			}
		}
		
		// Continue if atleast one ray hit something
		if (weightAmount > 0.0)
		{
			// Weight color
			ssr.rgb += reflectColor;
			ssr.rgb /= (weightAmount + 1.0);
			
			// Calculate screen fade
			vec2 dCoords = smoothstep(0.2, 0.6, abs(vec2(0.5, 0.5) - vTexCoord.xy));
			float screenEdgefactor = clamp(1.0 - (dCoords.x + dCoords.y), 0.0, 1.0);
			
			// Apply reflections + fade
			float fade = fresnelSchlick(max(dot(viewNormal, normalize(viewPos)), 0.0), 0.04) * clamp(reflected.z, 0.0, 1.0) * screenEdgefactor;
			ssr = mix(texture2D(uColorBuffer, vTexCoord), ssr, fade);
		}
	}
	
	gl_FragColor = ssr;
}