
sampler i_textureSampler = sampler_state { AddressU = WRAP; AddressV = WRAP; MinFilter = POINT; MagFilter = LINEAR; MipFilter = LINEAR; };


float4 i_colour;
float4 i_params;

struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0;

};

struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float2 ScreenPos : TEXCOORD1;


};
