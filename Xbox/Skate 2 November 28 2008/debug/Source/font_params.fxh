
float4x4 i_matWorld;
float4 i_colour;

sampler i_textureSampler = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; };


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0;

};

struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float4 Colour : TEXCOORD1;


};
