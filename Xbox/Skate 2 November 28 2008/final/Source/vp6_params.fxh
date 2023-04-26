
float4x4 i_matWorld;
sampler i_textureSampler;
sampler i_textureSampler1;
sampler i_textureSampler2;


struct VS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0;

};
struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0;

};
