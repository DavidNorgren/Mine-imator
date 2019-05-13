varying vec2 vTexCoord;

uniform sampler2D uHitBuffer;
uniform sampler2D uColorBuffer;
uniform sampler2D uDepthBuffer;

uniform vec2 uScreenSize;
//uniform sampler2D uNormalBuffer;

uniform float uRoughness;

vec2 unpackCoords(vec4 c) {
	return c.xy;
	
	return vec2(c.xy + (c.zw / 255.0));
}

float unpackDepth(vec4 c) {
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}

float getDepth(vec2 coords) {
	return unpackDepth(texture2D(uDepthBuffer, coords));
}

float specularPowerToConeAngle(float specularPower)
{
    const float xi = 0.244;
    float exponent = 1.0 / (specularPower + 1.0);
    return acos(pow(xi, exponent));
}

float isoscelesTriangleInRadius(float a, float h)
{
    float a2 = a * a;
    float fh2 = 4.0 * h * h;
    return (a * (sqrt(a2 + fh2) - a)) / (4.0 * h);
}

vec4 getBlur(vec2 coords, float size)
{
	vec2 texelSize = 1.0 / uScreenSize;
	
	vec4 totalColor = vec4(0.0);
	float weight = 0.0;
	for (int xx = -9; xx < 10; xx++)
	{
		for (int yy = -9; yy < 10; yy++)
		{
			float strength = smoothstep(0.0, 1.0, abs(float(xx) / 5.0)) * smoothstep(0.0, 1.0, abs(float(yy) / 5.0));
			totalColor += texture2D(uColorBuffer, coords + (vec2(float(xx), float(yy)) * size * texelSize)) * strength;
			weight += strength;
		}
	}
	return totalColor / weight;
}

vec4 coneSampleWeightedColor(vec2 samplePos, float blurSize, float gloss)
{
    vec3 sampleColor = getBlur(samplePos, blurSize).rgb;
    return vec4(sampleColor * gloss, gloss);
}

int checkHit()
{
	vec4 color = texture2D(uHitBuffer, vTexCoord);
	if (color.r == 1.0 && color.g == 1.0 && color.b == 1.0 && color.a == 1.0)
		return 0;
	else
		return 1;
}

void main()
{
	vec2 hitCoord = unpackCoords(texture2D(uHitBuffer, vTexCoord));
	
	float myDepth = getDepth(vTexCoord);
	
	// Get gloss and specular values
	float gloss = 1.0 - uRoughness;
	float specular = 2.0/pow(uRoughness, 4.0) - 2.0;
	float coneTheta = specularPowerToConeAngle(specular) * 0.5;
	
	// Get position values
	vec2 positionDelta = hitCoord - vTexCoord;
	float positionLength = length(positionDelta);
	
	// Set up color values
	vec4 totalColor = vec4(0.0);
	float alphaAmount = 1.0;
	float maxMipLevel = 0.0;
	float glossMultiplier = gloss;
	
	// Loop cone-tracing and gather pixels
	if (checkHit() > 0)
	{
		for (int i = 0; i < 14; i++)
		{
			// Get opposite side of cone
			float oppositeLength = 2.0 * tan(coneTheta) * positionLength;
			
			// Calculate radius of cone
			float circleSize = isoscelesTriangleInRadius(oppositeLength, positionLength);
			
			vec2 samplePos = vTexCoord + normalize(positionDelta) * (positionLength - circleSize);
			vec4 sampleColor = coneSampleWeightedColor(samplePos, clamp(log2(circleSize * max(uScreenSize.x, uScreenSize.y)), 0.0, 5.0), glossMultiplier);
			
			alphaAmount -= sampleColor.a;
			
			if (alphaAmount < 0.0)
				sampleColor.rgb *= (1.0 - abs(alphaAmount));
			
			totalColor += sampleColor;
			
			if (totalColor.a >= 1.0)
				break;
			
			positionLength = positionLength - (circleSize * 2.0);
			glossMultiplier *= gloss;
		}
	}
	/*
	// Calculate screen fade
	vec2 dCoords = smoothstep(0.2, 0.6, abs(vec2(0.5, 0.5) - vTexCoord.xy));
	float screenEdgefactor = clamp(1.0 - (dCoords.x + dCoords.y), 0.0, 1.0);
			
	// Set coordinates + fade
	float fadeAngle = normalize(reflect(viewPos, viewNormal)).z;
	float fade = fresnelSchlick(max(dot(viewNormal, normalize(viewPos)), 0.0), 0.04) * clamp(fadeAngle, 0.0, 1.0) * screenEdgefactor;
	*/
	totalColor = mix(texture2D(uColorBuffer, vTexCoord), (totalColor + texture2D(uColorBuffer, vTexCoord)) * 0.5, clamp(totalColor.a, 0.0, 1.0) * (1.0 - clamp(alphaAmount, 0.0, 1.0)));
	gl_FragColor = totalColor;
}
