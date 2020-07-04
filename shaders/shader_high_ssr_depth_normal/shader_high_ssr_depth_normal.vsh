uniform float uFar;
uniform float uNear;

struct VSInput
{
	float4 Position : POSITION;
	float3 Normal : NORMAL;
	float2 TexCoord : TEXCOORD0;
	float3 Color : COLOR;
	float3 Custom : TEXCOORD1;
};

struct VSOutput
{
	float4 Position : SV_POSITION;
	float2 TexCoord : TEXCOORD0;
	float Depth : DEPTH;
	float3 Normal : NORMAL;
	float3 Custom : TEXCOORD1;
};

// Wind
uniform float uTime;
uniform float uWindEnable;
uniform float uWindTerrain;
uniform float uWindSpeed;
uniform float uWindStrength;

float4 getWind(float4 pos, float3 custom)
{
	return float4(
		sin((uTime + pos.x * 10.0 + pos.y + pos.z) * (uWindSpeed / 5.0)) * max(custom.x * uWindTerrain, uWindEnable) * uWindStrength,
		sin((uTime + pos.x + pos.y * 10.0 + pos.z) * (uWindSpeed / 7.5)) * max(custom.x * uWindTerrain, uWindEnable) * uWindStrength,
		sin((uTime + pos.x + pos.y + pos.z * 10.0) * (uWindSpeed / 10.0)) * max(custom.y * uWindTerrain, uWindEnable) * uWindStrength,
		0
	);
}

float3x3 inverse(float4x4 Original)
{
	float det = Original[0][0] * Original[1][1] * Original[2][2]
			  + Original[0][1] * Original[1][2] * Original[2][0]
			  + Original[0][2] * Original[1][0] * Original[2][1]
			  - Original[0][0] * Original[1][2] * Original[2][1]
			  - Original[0][1] * Original[1][0] * Original[2][2]
			  - Original[0][2] * Original[1][1] * Original[2][0];
						
	float inv_det = 1.0 / det;
	
	float3x3 tmp;
	tmp[0][0] = Original[1][1] * Original[2][2] - Original[2][1] * Original[1][2];
	tmp[1][0] = Original[2][0] * Original[1][2] - Original[1][0] * Original[2][2];
	tmp[2][0] = Original[1][0] * Original[2][1] - Original[2][0] * Original[1][1];
	tmp[0][1] = Original[2][1] * Original[0][2] - Original[0][1] * Original[2][2];
	tmp[1][1] = Original[0][0] * Original[2][2] - Original[2][0] * Original[0][2];
	tmp[2][1] = Original[2][0] * Original[0][1] - Original[0][0] * Original[2][1];
	tmp[0][2] = Original[0][1] * Original[1][2] - Original[1][1] * Original[0][2];
	tmp[1][2] = Original[1][0] * Original[0][2] - Original[0][0] * Original[1][2];
	tmp[2][2] = Original[0][0] * Original[1][1] - Original[1][0] * Original[0][1];
	
	float3x3 Result;
	Result[0][0] = inv_det * tmp[0][0];
	Result[1][0] = inv_det * tmp[1][0];
	Result[2][0] = inv_det * tmp[2][0];
	Result[0][1] = inv_det * tmp[0][1];
	Result[1][1] = inv_det * tmp[1][1];
	Result[2][1] = inv_det * tmp[2][1];
	Result[0][2] = inv_det * tmp[0][2];
	Result[1][2] = inv_det * tmp[1][2];
	Result[2][2] = inv_det * tmp[2][2];
	
	return transpose(Result);
}

VSOutput main(VSInput IN)
{
	VSOutput OUT;
	
	// Diffuse
	OUT.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], IN.Position + getWind(IN.Position, IN.Custom));
	OUT.TexCoord = IN.TexCoord;
	
	// Depth
	OUT.Depth = (OUT.Position.z - uNear) / (uFar - uNear);
	
	// Normal
	OUT.Normal = normalize(mul(inverse(gm_Matrices[MATRIX_WORLD_VIEW]), IN.Normal));
	
	// Custom
	OUT.Custom = IN.Custom;
	
	return OUT;
}

