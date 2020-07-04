#define MAXSTEPS 500
#define MAXREFINESTEPS 30
#define SAMPLES 1

varying vec2 vTexCoord;

// Buffers
uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;
uniform sampler2D uNormalBufferExp;
uniform sampler2D uColorBuffer;

// Camera data
uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;
uniform mat4 uViewMatrix;
uniform mat4 uViewMatrixInv;
uniform float uNear;
uniform float uFar;

// Material data/settings
uniform float uStepSize; // Default: 2.0
uniform int uStepAmount; // Default: 140
uniform int uRefineSteps; // Default: 30
uniform float uRefineDepthTest; // Default 4.0
uniform float uMetallic; // Default: 1.0
uniform float uRoughness; // Default: 0.0
const float specularFalloffExp = 3.0;

uniform vec4 uSkyColor;

// Unpacks depth value from packed color
float unpackDepth(vec4 c)
{
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}

// Returns depth value from packed depth buffer
float getDepth(vec2 coords)
{
	return unpackDepth(texture2D(uDepthBuffer, coords));
}

// Transforms Z depth with camera data
float transformDepth(float depth)
{
	return (uFar - (uNear * uFar) / (depth * (uFar - uNear) + uNear)) / (uFar - uNear);
}

// Reconstruct a position from a screen space coordinate and (linear) depth
vec3 posFromBuffer(vec2 coord, float depth)
{
	vec4 pos = uProjMatrixInv * vec4(coord.x * 2.0 - 1.0, 1.0 - coord.y * 2.0, transformDepth(depth), 1.0);
	return pos.xyz / pos.w;
}

float unpackFloat2(float expo, float dec)
{
	return (expo * 255.0 * 255.0) + (dec * 255.0);
}

// Get normal Value
vec3 getNormal(vec2 coords)
{
	vec3 nDec = texture2D(uNormalBuffer, coords).rgb;
	vec3 nExp = texture2D(uNormalBufferExp, coords).rgb;
	
	return (vec3(unpackFloat2(nExp.r, nDec.r), unpackFloat2(nExp.g, nDec.g), unpackFloat2(nExp.b, nDec.b)) / (255.0 * 255.0)) * 2.0 - 1.0;
}

// Fresnel Schlick approximation
float fresnelSchlick(float cosTheta, float F0)
{
	return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

// Hash scatter function
vec3 hash(vec3 a)
{
	a = fract(a * vec3(.8));
	a += dot(a, a.yxz + 19.19);
	return fract((a.xxy + a.yxx) * a.zyx);
}

// Refines ray position if ray hits an object
vec2 BinarySearch(vec3 dir, inout vec3 hitCoord, out float dDepth)
{
	vec3 screenPos;
	int steps = 0;
	
	// Refine coordinate
	for (int i = 0; i < MAXREFINESTEPS; i++)
	{
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
		
		// Break loop if steps reach max
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

// Casts ray from camera for n amount of steps given a step amount and direction
vec2 RayCast(vec3 dir, inout vec3 hitCoord, out float dDepth)
{
	dir *= uStepSize;
	
	vec3 startPos = hitCoord;
	vec3 screenPos = vec3(hitCoord);
	int steps = 0;
	vec4 projectedCoord;
	vec2 screenCoord = vec2(1.0);
	
	for (int i = 0; i < MAXSTEPS; i++)
	{
		hitCoord += dir;

		projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
		screenCoord = (projectedCoord.xy / projectedCoord.w) * 0.5 + 0.5;
		
		if (screenCoord.x < 0.0 || screenCoord.x > 1.0 || screenCoord.y < 0.0 || screenCoord.y > 1.0)
			break;
		
		screenCoord.y = 1.0 - screenCoord.y;
		screenPos = posFromBuffer(screenCoord, getDepth(screenCoord));
		
		dDepth = screenPos.z - hitCoord.z;
		
		if (startPos.z < screenPos.z)
		{
			if (dDepth <= 0.0 && dDepth > -uRefineDepthTest)
				return BinarySearch(dir, hitCoord, dDepth);
		}
		
		// Break loop if steps reach max
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

void main()
{
	// Sample buffers
	vec4 diffuseColor = texture2D(uColorBuffer, vTexCoord);
	vec3 viewPos = posFromBuffer(vTexCoord, getDepth(vTexCoord));
	vec3 viewNormal = getNormal(vTexCoord);
	
	vec3 wp = vec3(vec4(viewPos, 1.0) * uViewMatrixInv);
	vec3 wn = normalize(vec3(vec4(viewNormal, 0.0) * uViewMatrix));
	
	vec3 hitPos = viewPos;
	
	float weight = 1.0;
	vec4 refColor = diffuseColor;
	vec2 coords = vec2(0.0);
	float dDepth = -1.0;
	
	// Only do reflections on visible surfaces
	if (texture2D(uDepthBuffer, vTexCoord).a > 0.0 && uMetallic > 0.01)
	{
		// Sample positions
		for (int i = 0; i < SAMPLES; i++)
		{
			hitPos = viewPos;
			dDepth = -1.0;
			
			vec3 jitt = mix(vec3(0.0), (vec3(hash(wp + float(i))) - 0.5) * 2.0, mix(0.0, 0.20, uRoughness));
			vec3 reflected = normalize(reflect(hitPos, normalize(viewNormal + jitt)));
			
			coords = RayCast(reflected, hitPos, dDepth);
			
			if (dDepth > 0.0)
				coords = vec2(-1.0);
			
			if (coords.x >= 0.0)
			{
				vec2 fadeCoords = smoothstep(0.2, 0.6, abs(vec2(0.5, 0.5) - coords.xy));
				float fadeAmount = clamp(1.0 - (fadeCoords.x + fadeCoords.y), 0.0, 1.0);
				
				refColor.rgb += texture2D(uColorBuffer, coords).rgb * fadeAmount;
				weight += fadeAmount;
			}
			else
			{
				refColor.rgb += uSkyColor.rgb;
				weight += 1.0;
			}
		}
	}
	
	refColor.rgb /= weight;
	
	// Reflection amount
	vec3 refDir = reflect(viewPos, viewNormal);
	float refAmount = clamp(pow(uMetallic, specularFalloffExp) * refDir.z, 0.0, 0.9);
	
	// Fresnel
	float F0 = 0.04;
	F0 = mix(F0, 0.0, uMetallic);
	float fresnel = fresnelSchlick(max(dot(viewNormal, normalize(viewPos)), 0.0), F0);
	
	float vis = refAmount * fresnel;
	
	// Optional, limits reflections to surfaces facing up
	//vis *= max(0.0, wn.z);
	
	// Combine visibility inputs and mix result
	vec4 blendColor = mix(diffuseColor, refColor, vis);
	
	gl_FragColor = blendColor;
	gl_FragColor.a = diffuseColor.a;
}