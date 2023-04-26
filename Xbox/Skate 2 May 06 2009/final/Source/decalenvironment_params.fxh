
float4x4 i_matWorld;

sampler i_decal = sampler_state { AddressU = CLAMP; AddressV = CLAMP; MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_detail = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_macrooverlay = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
samplerCUBE i_environment = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR; Mipfilter = POINT; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 1 ];


struct VS_IN
{
float3 pos : POSITION; float4 uv_decal : TEXCOORD0; float4 lm_norm : TEXCOORD1; float3 tangent : TANGENT;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vTangent : TEXCOORD2; float3 vBinormal : TEXCOORD3; float3 vPos : TEXCOORD4; float2 Decal : TEXCOORD5; float4 Fog : TEXCOORD6; float4 lightmapchannel : TEXCOORD7; float4 dataconstants : TEXCOORD8;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
