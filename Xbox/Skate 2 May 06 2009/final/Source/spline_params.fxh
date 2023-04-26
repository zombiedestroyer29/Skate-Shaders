
float4x4 i_matWorld;
float4 i_cp [ 192 ];
float4 i_basis [ 4 ];
float4 i_intensity;
float4 i_clipvalues;
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; MaxAnisotropy = 8; };


struct VS_IN
{
float3 Pos : POSITION;

};
struct PS_IN
{
float4 Pos : POSITION; float4 intensity : TEXCOORD0; float3 UV : TEXCOORD1;


};
