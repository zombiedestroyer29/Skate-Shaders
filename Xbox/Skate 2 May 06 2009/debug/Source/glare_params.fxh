
float4x4 i_matWorld;


sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; MaxAnisotropy = 8; };


float4 m_params [ 1 ];


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0;

};
struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0;

};
