
float4x4 i_matWorld;
sampler i_diffuse;
float4 i_colortint;


float4 m_params [ 1 ];


struct VS_IN
{
float3 Pos : POSITION; float3 vNormal : NORMAL; float2 UV : TEXCOORD0;


};
struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float4 Fog : TEXCOORD1;


};
