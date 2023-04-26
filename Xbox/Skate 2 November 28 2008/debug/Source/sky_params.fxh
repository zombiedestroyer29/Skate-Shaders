
float4x4 i_matWorld;
sampler i_diffuse = sampler_state { AddressU = WRAP; AddressV = CLAMP; MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_detail = sampler_state { AddressU = WRAP; AddressV = CLAMP; MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { AddressU = CLAMP; AddressV = CLAMP; MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 2 ];


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0;

};
struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float3 vPos : TEXCOORD2;


};
struct VS_IN_SIMPLE
{
float3 Pos : POSITION;
};

struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
