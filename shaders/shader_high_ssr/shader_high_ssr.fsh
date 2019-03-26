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

const int maxf = 4;				// Max number of refinements
const float ref = 0.25;			// Refinement multiplier
const float inc = 2.0;		// Increasement factor for each ray step

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
	return unpackDepth(texture2D(uDepthBuffer, coords));
}

vec3 posFromBuffer(vec2 coord, float depth)
{
	vec4 pos = uProjMatrixInv * vec4(coord.x * 2.0 - 1.0, 1.0 - coord.y * 2.0, transformDepth(depth), 1.0);
	return pos.xyz / pos.w;
}

vec2 RayCast(vec3 reflectDir, vec3 startPos)
{	
	vec3 stepVector = reflectDir * (1.2 - 0.5);
	vec3 tVector = stepVector;
	
	vec3 curCoord = startPos + stepVector;
	
	int refinements = 0;
	
    for (int i = 0; i < 25; i++) {
		vec4 projPos = uProjMatrix * vec4(curCoord, 1.0);
        vec2 projCoord = (projPos.xy / projPos.w) * 0.5 + 0.5;
		projCoord.y = 1.0 - projCoord.y;
		
		if (projCoord.x < 0.0 || projCoord.x > 1.0 || projCoord.y < 0.0 || projCoord.y > 1.0)
			break;
		
        vec3 screenPos = posFromBuffer(projCoord, getDepth(projCoord));
		
		if (screenPos.z <= curCoord.z)
		{
			refinements++;
			
			if (refinements >= maxf)
				return projCoord;
			
			tVector -= stepVector;
            stepVector *= ref;
		}
		
		stepVector *= inc;
		tVector += stepVector;
		curCoord = startPos + tVector;
    }
	
	return vec2(-1.0);
}

float cdist(vec2 coord) {
	return clamp(1.0 - max(abs(coord.x - 0.5), abs(coord.y - 0.5)) * 2.0, 0.0, 1.0);
}

void main()
{
	vec3 viewNormal = unpackNormal(texture2D(uNormalBuffer, vTexCoord));
	
	vec3 viewPos = posFromBuffer(vTexCoord, getDepth(vTexCoord));
	vec3 reflected = normalize(reflect(viewPos, viewNormal));
	
	vec3 startPos = viewPos;
	
	vec4 ssr = texture2D(uColorBuffer, vTexCoord);
	
	if (texture2D(uNormalBuffer, vTexCoord).a > 0.0)
	{
		vec2 coords = RayCast(reflected, startPos);
	
		if (coords.x > -1.0)
			ssr.rgb = mix(ssr.rgb, texture2D(uColorBuffer, coords.xy).rgb, cdist(coords.xy));
			//ssr = (ssr + texture2D(uColorBuffer, coords.xy)) * 0.5;
	}
	
	gl_FragColor = ssr;// *0.0001 + vec4(reflected, 1.0);
}