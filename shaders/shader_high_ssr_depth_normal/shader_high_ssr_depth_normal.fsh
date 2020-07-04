uniform float2 uTexScale;
uniform float4 uBlendColor;

struct FSInput
{
	float4 Position : SV_POSITION;
	float2 TexCoord : TEXCOORD0;
	float Depth : DEPTH;
	float3 Normal : NORMAL;
	float3 Custom : TEXCOORD1;
};

struct FSOutput
{
	float4 Color0 : SV_Target0;
	float4 Color1 : SV_Target1;
	float4 Color2 : SV_Target2;
};

Texture2D uTextureT : register(t1);
SamplerState uTexture : register(s1);

float4 packDepth(float f)
{
	return float4(floor(f * 255.0) / 255.0, frac(f * 255.0), frac(f * 255.0 * 255.0), 1.0);
}

float4 packNormal(float3 n)
{
	return float4((n + float3(1.0, 1.0, 1.0)) / 2.0, 1.0);
}

float2 packFloat2(float f)
{
	return float2(floor(f / 255.0) / 255.0, frac(f / 255.0));
}

FSOutput main(FSInput IN) : SV_TARGET
{
	FSOutput OUT;
	
	// Alpha test
	float2 tex = fmod(IN.TexCoord * uTexScale, uTexScale);
	float4 baseColor = uTextureT.Sample(uTexture, tex);
	clip((baseColor.a < .01) ? -1 : 1);
	
	// Depth
	OUT.Color0 = packDepth(IN.Depth);
	
	float3 n = float3((IN.Normal + float3(1.0, 1.0, 1.0)) / 2.0);
	
	// Normal X
	float2 channel = float2(0.0, 0.0);
	channel = packFloat2(n.r * 255.0 * 255.0);
	OUT.Color1.r = channel.y;
	OUT.Color2.r = channel.x;
	
	// Normal Y
	channel = packFloat2(n.g * 255.0 * 255.0);
	OUT.Color1.g = channel.y;
	OUT.Color2.g = channel.x;
	
	// Normal Z
	channel = packFloat2(n.b * 255.0 * 255.0);
	OUT.Color1.b = channel.y;
	OUT.Color2.b = channel.x;
	
	OUT.Color1.a = 1.0;
	OUT.Color2.a = 1.0;
	
	
	return OUT;
}