
float4x4 i_matWorld;

sampler i_detail = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_macrooverlay = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };

samplerCUBE i_environment = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR; Mipfilter = POINT; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 1 ];


struct VS_IN
{
float3 pos : POSITION; float2 uv : TEXCOORD0; float2 lm : TEXCOORD1; float3 normal : NORMAL;


};

struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vPos : TEXCOORD2; float4 lightmapchannel : TEXCOORD3;


};

struct VS_IN_NOLM
{
float3 pos : POSITION; float2 uv : TEXCOORD0; float3 normal : NORMAL;


};

struct PS_IN_NOLM
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vPos : TEXCOORD2;


};
