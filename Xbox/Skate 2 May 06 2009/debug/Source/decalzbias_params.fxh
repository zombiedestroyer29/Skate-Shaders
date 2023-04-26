
float4x4 i_matWorld;

sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 1 ];


struct VS_IN
{
float3 pos : POSITION; float2 uv : TEXCOORD0; float4 lm_norm : TEXCOORD1; float3 tangent : TANGENT;


};
struct VS_IN_BACKLIT
{
float3 Pos : POSITION; float2 UV : TEXCOORD0; float2 LM : TEXCOORD1; float3 vTangent : TANGENT; float3 vBinormal : BINORMAL;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vTangent : TEXCOORD2; float3 vBinormal : TEXCOORD3; float3 vPos : TEXCOORD4; float4 Fog : TEXCOORD5; float4 lightmapchannel : TEXCOORD6;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
