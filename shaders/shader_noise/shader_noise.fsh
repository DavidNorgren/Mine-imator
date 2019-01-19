varying vec2 vTexCoord;

uniform float uTime;
uniform float uStrength;
uniform float uSaturation;
uniform float uSize;

uniform vec2 uScreenSize;


vec4 hsbtorgb(vec4 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return vec4(c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y), c.a);
}

float random(vec2 coord)
{
	vec2 K = vec2(23.14069263277926, 2.665144142690225);
	return fract(cos(dot(coord, K)) * 12345.6789);
}

void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);



	/*
	
	vec2 randomCoord = (((floor((vTexCoord * uScreenSize) / uSize)) * uSize) / uScreenSize) + (1.0 / uScreenSize) * uSize;
	
	randomCoord.y *= random(vec2(randomCoord.y, uTime));
	
	vec4 noisecolor = hsbtorgb(vec4(random(randomCoord), 1.0, 1.0, 1.0));
	
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(noisecolor.rgb, W));
	noisecolor.rgb = mix(satIntensity, noisecolor.rgb, uSaturation);
		
	baseColor.rgb += vec3(noisecolor.rgb) * uStrength;//vec3(random(randomCoord), random(randomCoord * vec2(3.0, -2.0)), random(randomCoord * vec2(2.0, -5.0))) * uStrength;
	*/
	gl_FragColor = vec4(baseColor);
}