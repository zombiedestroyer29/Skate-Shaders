
float4x4 i_matWorld;


sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
samplerCUBE i_environment = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR; Mipfilter = POINT; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 1 ];


float4 i_shmult [ 9 ];

struct VS_IN
{
float3 pos : POSITION; float2 uv : TEXCOORD0; float4 lm_norm : TEXCOORD1;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vPos : TEXCOORD2; float4 Fog : TEXCOORD3; float4 lightmapchannel : TEXCOORD4;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
