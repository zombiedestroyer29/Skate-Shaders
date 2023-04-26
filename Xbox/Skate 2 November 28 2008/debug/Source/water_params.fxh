
float4 m_params [ 4 ];


struct VS_IN_STATIC
{
float3 Pos : POSITION; float2 UV : TEXCOORD0; float2 LM : TEXCOORD1;


};

struct VS_IN_FLOWING
{
float3 pos : POSITION; float2 uv : TEXCOORD0; float4 lm_norm : TEXCOORD1; float3 tangent : TANGENT;


};
struct PS_IN_FLOWING
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vTangent : TEXCOORD2; float3 vBinormal : TEXCOORD3; float3 vPos : TEXCOORD4; float4 Fog : TEXCOORD5; float4 lightmapchannel : TEXCOORD6;


};
struct PS_IN_STATIC
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vPos : TEXCOORD1; float4 Fog : TEXCOORD2; float4 lightmapchannel : TEXCOORD3;


};


sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };

sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal2 = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
samplerCUBE i_environment = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; MaxAnisotropy = 8; };


float4 g_fAnimationTime;
half4 GetAnimatedUV ( half4 scale , half4 speed , half2 uv ) 
{
return scale*uv.xyxy+speed*g_fAnimationTime.x;
}
