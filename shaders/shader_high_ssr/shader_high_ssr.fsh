#define MAXSTEPS 200
#define MAXREFINESTEPS 30

uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;
uniform sampler2D uColorBuffer;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;
uniform mat4 uViewMatrixInv;

varying vec2 vTexCoord;

uniform float uNear;
uniform float uFar;

uniform float uStepSize; // 2.0
uniform int uStepAmount; // 140
uniform int uRefineSteps; // 30
uniform float uRefineDepthTest;
uniform float uMetallic; // 1.0
uniform float uSpecular;
const float specularFalloffExp = 3.0;

vec4 packCoords(vec2 coords) {
	return vec4(coords, 0.0, 1.0);
	
	vec2 maxcoords = coords * 255.0;
	return vec4(floor(maxcoords * 255.0) / (255.0 * 255.0), fract(maxcoords * 255.0));
}

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
	vec2 screenCoord = vec2(1.0);
	
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
			if (dDepth <= 0.0 && dDepth > -uRefineDepthTest)
				return BinarySearch(dir, hitCoord, dDepth);
		}
		
		if (steps > uStepAmount) {
			dDepth = 1.0;
			break;
		}
		
		steps++;
    }
	
	dDepth = 1.0;
    return screenCoord;
}

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

#define Scale vec3(.8)
#define K 19.19
vec3 hash(vec3 a)
{
    a = fract(a * Scale);
    a += dot(a, a.yxz + K);
    return fract((a.xxy + a.yxx) * a.zyx);
}

void main() {
	float depth = getDepth(vTexCoord);
	vec3 viewNormal = normalize(unpackNormal(texture2D(uNormalBuffer, vTexCoord)));
	
	vec3 viewPos = posFromBuffer(vTexCoord, depth);
	
	vec3 hitPos = viewPos;
	float dDepth = -1.0;
	
	vec4 baseColor = texture2D(uColorBuffer, vTexCoord);
	vec4 ssr = baseColor;
	
	// Fresnel
	vec3 F0 = vec3(0.04);
    F0 = mix(F0, vec3(0.0), uMetallic);
    vec3 fresnel = fresnelSchlick(max(dot(normalize(viewNormal), normalize(viewPos)), 0.0), F0);
	
	vec3 wp = vec3(vec4(viewPos, 1.0) * uViewMatrixInv);
	vec3 jitt = mix(vec3(0.0), (vec3(hash(wp)) - 0.5) * 2.0, mix(0.0, 0.20, uSpecular));
	
	// Reflect vector
	vec3 reflected = normalize(reflect(hitPos, normalize(viewNormal + jitt)));
	
	// Only do reflections on visible surfaces
	vec2 coords = vec2(-1.0);
	
	if (texture2D(uDepthBuffer, vTexCoord).a > 0.0 && uMetallic > 0.01) {
		coords = RayCast(reflected * max(1.0, -viewPos.z), hitPos, dDepth);	
	
		if (dDepth > 0.0)
			coords = vec2(-1.0);
	}
	
	// Calculate screen fade
	vec2 dCoords = smoothstep(0.2, 0.6, abs(vec2(0.5, 0.5) - coords.xy));
	float screenEdgefactor = clamp(1.0 - (dCoords.x + dCoords.y), 0.0, 1.0);
	
	// Reflection amount
	float refAmount = pow(uMetallic, specularFalloffExp) * screenEdgefactor * reflected.z;
	
	if (coords.x >= 0.0)
		ssr.rgb = texture2D(uColorBuffer, coords).rgb;
	else
		ssr.rgb = baseColor.rgb;
	
	ssr.rgb = mix(baseColor.rgb, ssr.rgb, uMetallic * clamp(refAmount, 0.0, 0.9) * fresnel);
	
	gl_FragColor = ssr;
	gl_FragColor.a = baseColor.a;
}