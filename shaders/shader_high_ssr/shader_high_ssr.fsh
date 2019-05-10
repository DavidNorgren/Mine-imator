uniform sampler2D uColorBuffer;
uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;
uniform mat4 uViewMatrixInv;

varying vec2 vTexCoord;

uniform float uNear;
uniform float uFar;

float step = 1.5;
float minRayStep = 1.0;
int maxSteps = 160;
int numBinarySearchSteps = 5;
float reflectionSpecularFalloffExponent = 3.0;

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

vec3 BinarySearch(vec3 dir, inout vec3 hitCoord, out float dDepth);

vec2 RayCast(vec3 dir, inout vec3 hitCoord, out float dDepth) {
    dir *= step;
	
	vec3 screenPos = vec3(hitCoord);
	float steps = 0.0;
	vec4 projectedCoord;
	
    for (int i = 0; i < maxSteps; i++) {
        hitCoord += dir;

        projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
        vec2 screenCoord = (projectedCoord.xy / projectedCoord.w) * 0.5 + 0.5;
		screenCoord.y = 1.0 - screenCoord.y;
		
		screenPos = posFromBuffer(screenCoord, getDepth(screenCoord));
		
		if (screenCoord.x < 0.0 || screenCoord.x > 1.0 || screenCoord.y < 0.0 || screenCoord.y > 1.0)
			break;
		
		if (screenPos.z > uFar)
			continue;
		
        dDepth = screenPos.z - hitCoord.z;
		
		//if ((dir.z - dDepth) < 1.2) {
			if (dDepth <= 0.0)
				return screenCoord;
		//}
		steps += 1.0;
    }
	
	dDepth = 1.0;
    return vec2(0.0);
}

#define Scale vec3(.8, .8, .8)
#define K 19.19
vec3 hash(vec3 a)
{
    a = fract(a * Scale);
    a += dot(a, a.yxz + K);
    return fract((a.xxy + a.yxx)*a.zyx);
}


float fresnelSchlick(float cosTheta, float F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main()
{
	float depth = getDepth(vTexCoord);
	vec3 viewNormal = unpackNormal(texture2D(uNormalBuffer, vTexCoord));
	
	vec3 viewPos = posFromBuffer(vTexCoord, depth);
	vec3 reflected = normalize(reflect(viewPos, viewNormal));
	
	vec3 hitPos = viewPos;
	float dDepth;
	
	vec3 wp = vec3(vec4(viewPos, 1.0) * uViewMatrixInv);
	vec3 jitt = mix(vec3(0.0), vec3(hash(wp)), 0.005);
	
	vec4 ssr = texture2D(uColorBuffer, vTexCoord);
	
	if (texture2D(uDepthBuffer, vTexCoord).a < 1.0)
	{
		gl_FragColor = ssr;
	}
	else
	{
		vec2 coords = RayCast(vec3(jitt) + reflected * max(minRayStep, -viewPos.z), hitPos, dDepth);
		
		vec2 dCoords = smoothstep(0.2, 0.6, abs(vec2(0.5, 0.5) - vTexCoord.xy));
		float screenEdgefactor = clamp(1.0 - (dCoords.x + dCoords.y), 0.0, 1.0);
		
		if (dDepth < 0.0)
			ssr = (ssr + texture2D(uColorBuffer, coords.xy)) * 0.5;
		
		float fade = fresnelSchlick(max(dot(viewNormal, normalize(viewPos)), 0.0), 0.04) * clamp(reflected.z, 0.0, 1.0) * screenEdgefactor;
		ssr = mix(texture2D(uColorBuffer, vTexCoord), ssr, fade);
	
		gl_FragColor = ssr;// *0.0001 + vec4(reflected, 1.0);
	}
}


vec3 BinarySearch(vec3 dir, inout vec3 hitCoord, out float dDepth) {
    float depth;

    for (int i = 0; i < numBinarySearchSteps; i++) {
        vec4 projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
        projectedCoord.xy /= projectedCoord.w;
        projectedCoord.xy = projectedCoord.xy * 0.5 + 0.5;

        depth = getDepth(projectedCoord.xy);
		
        dDepth = hitCoord.z - depth;
		
        if(dDepth > 0.0)
            hitCoord += dir;
		
        dir *= 0.5;
        hitCoord -= dir;
    }
	
    vec4 projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
    projectedCoord.xy /= projectedCoord.w;
    projectedCoord.xy = projectedCoord.xy * 0.5 + 0.5;

    return vec3(projectedCoord.xy, depth);
}


/*

vec4 RayCast(vec3 dir, inout vec3 hitCoord, out float dDepth)
{
    dir *= step;

    float depth;
    vec4 projectedCoord;

    for(int i = 0; i < maxSteps; i+=1)
    {
        hitCoord += dir;

        projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
        projectedCoord.xy /= projectedCoord.w;
        projectedCoord.xy = projectedCoord.xy * 0.5 + 0.5;

        depth = transformDepth(unpackDepth(texture2D(uDepthBuffer, projectedCoord.xy)));
		
        if (depth > uFar)
            continue;

        dDepth = hitCoord.z - depth;

        if ((dir.z - dDepth) < 1.2)
        {
            if(dDepth <= 0.0)
            {
                vec4 Result;
                Result = vec4(BinarySearch(dir, hitCoord, dDepth), 1.0);

                return Result;
            }
        }

    }

    return vec4(projectedCoord.xy, depth, 0.0);
}
*/