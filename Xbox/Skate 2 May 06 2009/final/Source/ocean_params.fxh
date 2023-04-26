
float4 m_params [ 3 ];


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0; float2 LM : TEXCOORD1;


};

struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vPos : TEXCOORD1; float4 Fog : TEXCOORD2; float4 lightmapchannel : TEXCOORD3; float4 dataconstants : TEXCOORD4;


};


sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal2 = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_macrooverlay = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
samplerCUBE i_environment = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; MaxAnisotropy = 8; };
