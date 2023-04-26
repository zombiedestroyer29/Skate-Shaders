
sampler i_diffuse;
sampler i_normal;
sampler i_specular;

float4 i_boneArray [ 61*3 ];


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0; float3 vTangent : TANGENT; float3 vBinormal : BINORMAL; float4 BoneIndices : BLENDINDICES; float4 BoneWeights : BLENDWEIGHT;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vTangent : TEXCOORD2; float3 vBinormal : TEXCOORD3; float3 vPos : TEXCOORD4; float4 Fog : TEXCOORD5;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
