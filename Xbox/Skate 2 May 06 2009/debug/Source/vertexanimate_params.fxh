
float4x4 i_matWorld;
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_macrooverlay = sampler_state { MinFilter = LINEAR; MagFilter = LINEAR; Mipfilter = POINT; };

float4 g_fAnimationTime;


float4 m_params [ 3 ];


struct VS_IN
{
float3 pos : POSITION; float2 uv : TEXCOORD0; float4 lm_effectuv : TEXCOORD1;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float4 Fog : TEXCOORD1; float4 lightmapchannel : TEXCOORD2;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
