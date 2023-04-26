
float4x4 i_matWorld;

sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 1 ];


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0; float2 LM : TEXCOORD1;


};

struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vPos : TEXCOORD1; float4 Fog : TEXCOORD2; float4 lightmapchannel : TEXCOORD3;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
