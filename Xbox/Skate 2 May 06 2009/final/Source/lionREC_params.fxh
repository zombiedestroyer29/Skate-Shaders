
sampler i_textureSampler;
struct VS_IN
{
float3 ObjPos : POSITION; float4 Color : COLOR; float2 UV : TEXCOORD0;


};

struct PS_IN
{
float4 ProjPos : POSITION; float4 Color : TEXCOORD0; float4 UVFog : TEXCOORD1;


};
