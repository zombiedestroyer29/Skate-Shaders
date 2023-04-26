
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_alpha;
float4 i_boneArray [ 61*3 ];
float4x4 i_matWorld;
float4 i_shmult [ 9 ];

struct VS_IN
{
float3 Pos : POSITION; float2 UV0 : TEXCOORD0; float2 UV1 : TEXCOORD1; float3 vTangent : TANGENT; float3 vBinormal : BINORMAL; float4 BoneIndices : BLENDINDICES; float4 BoneWeights : BLENDWEIGHT;


};
struct VS_IN_ROPA
{
float3 Pos : POSITION; float3 vNormal : NORMAL; float2 UV0 : TEXCOORD0; float2 UV1 : TEXCOORD1; float3 vTangent : TANGENT; float3 vBinormal : BINORMAL; float4 BoneIndices : BLENDINDICES; float4 BoneWeights : BLENDWEIGHT;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vTangent : TEXCOORD2; float3 vBinormal : TEXCOORD3; float3 vPos : TEXCOORD4; float4 Fog : TEXCOORD5;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
