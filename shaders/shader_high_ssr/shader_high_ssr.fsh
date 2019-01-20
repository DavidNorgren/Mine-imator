uniform vec2 uScreenSize;
uniform float uPower;

uniform sampler2D uColorBuffer;
uniform sampler2D uDepthBuffer;
uniform sampler2D uNormalBuffer;

uniform mat4 uProjMatrix;
uniform mat4 uProjMatrixInv;
uniform mat4 uViewMatrix;
uniform mat4 uViewMatrixInv;

varying vec2 vTexCoord;

float uNear = 0.1;
float uFar = 5000.0;

float step = 10.0;
float minRayStep = 10.0;
int maxSteps = 30;
int numBinarySearchSteps = 5;
float reflectionSpecularFalloffExponent = 3.0;

//vec2 texelSize = 1.0 / uScreenSize;

float unpackDepth(vec4 c)
{
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}

vec3 unpackNormal(vec4 c)
{
    return c.rgb * 2.0 - 1.0;
}

float transformDepth(float depth)
{
    return depth * (uFar - uNear) + uNear;
}

// Reconstruct a position from a screen space coordinate and (linear) depth
vec3 posFromBuffer(vec2 coord, float depth)
{
    vec4 pos = uProjMatrixInv * vec4(coord.x * 2.0 - 1.0, 1.0 - coord.y * 2.0, depth, 1.0);
    return pos.xyz / pos.w;
}

vec3 BinarySearch(vec3 dir, inout vec3 hitCoord, out float dDepth);

float getDepth(vec2 coords){
	return transformDepth(unpackDepth(texture2D(uDepthBuffer, coords)));
}

vec3 CalcViewPositionFromDepth(in vec2 TexCoord)
{
    // Combine UV & depth into XY & Z (NDC)
    vec3 rawPosition                = vec3(TexCoord, getDepth(TexCoord));

	rawPosition.y = 1.0 - rawPosition.y;

    // Convert from (0, 1) range to (-1, 1)
    vec4 ScreenSpacePosition        = vec4( rawPosition * 2.0 - 1.0, 1.0);

    // Undo Perspective transformation to bring into view space
    vec4 ViewPosition               = uProjMatrixInv * ScreenSpacePosition;

    // Perform perspective divide and return
    return                          ViewPosition.xyz / ViewPosition.w;
}


vec2 RayCast(vec3 dir, inout vec3 hitCoord, out float dDepth)
{
    dir *= 0.25;

    for(int i = 0; i < 20; ++i) {
        hitCoord               += dir;

        vec4 projectedCoord     =   uProjMatrix * vec4(hitCoord, 1.0);
        projectedCoord.xy      /=   projectedCoord.w;
        projectedCoord.xy       =   projectedCoord.xy * 0.5 + 0.5; 

        float depth             =   CalcViewPositionFromDepth(projectedCoord.xy).z;
		
		if(depth > uFar)
			continue;
		
        dDepth                  =   hitCoord.z - depth;

        if(dDepth < 0.0)
            return projectedCoord.xy;
    }

    return vec2(0.0);
}

void main()
{
	float depth = unpackDepth(texture2D(uDepthBuffer, vTexCoord));
	vec3 viewNormal = unpackNormal(texture2D(uNormalBuffer, vTexCoord));
	vec3 viewPos = CalcViewPositionFromDepth(vTexCoord);//posFromBuffer(vTexCoord, depth);
	vec3 reflected = normalize(reflect(normalize(viewPos), normalize(viewNormal)));
	
	vec3 hitPos = viewPos;
	float dDepth;
	
	vec3 dir;
	dir = reflected * max(minRayStep, -viewPos.z);
	
	vec2 coords = RayCast(dir, hitPos, dDepth);
	coords.y = 1.0 - coords.y;
	
	vec4 ssr = texture2D(uColorBuffer, vTexCoord);
	
	if(dDepth < 0.0)
		ssr = (ssr + texture2D(uColorBuffer, coords.xy)) * 0.5;
	
	gl_FragColor = ssr;// *0.0001 + vec4(reflected, 1.0);
}


vec3 BinarySearch(vec3 dir, inout vec3 hitCoord, out float dDepth)
{
    float depth;

    for(int i = 0; i < numBinarySearchSteps; i++)
    {
        vec4 projectedCoord = uProjMatrix * vec4(hitCoord, 1.0);
        projectedCoord.xy /= projectedCoord.w;
        projectedCoord.xy = projectedCoord.xy * 0.5 + 0.5;

        depth = transformDepth(unpackDepth(texture2D(uDepthBuffer, projectedCoord.xy)));
		
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