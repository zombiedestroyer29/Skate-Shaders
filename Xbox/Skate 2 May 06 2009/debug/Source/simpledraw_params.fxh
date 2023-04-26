
float4x4 i_matWorld;
float4 i_ConstantColour;
float4 i_ConstantLightPos;
float4 i_ConstantDepth;
sampler i_textureSampler = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; };


struct VS_IN_CLR_NORM_UV
{
float4 Pos : POSITION; float4 Norm : NORMSIMPLEDRAWAL; float4 Colour : COLOR; float2 UV : TEXCOORD0;


};

struct VS_IN_CLR_NORM
{
float4 Pos : POSITION; float4 Norm : NORMAL; float4 Colour : COLOR;


};
struct VS_IN_NORM_UV
{
float4 Pos : POSITION; float4 Norm : NORMAL; float2 UV : TEXCOORD0;


};
struct VS_IN_CLR_UV
{
float4 Pos : POSITION; float4 Colour : COLOR; float2 UV : TEXCOORD0;


};
struct VS_IN_UV
{
float4 Pos : POSITION; float2 UV : TEXCOORD0;

};
struct VS_IN_NORM
{
float4 Pos : POSITION; float4 Norm : NORMAL;

};
struct VS_IN_CLR
{
float4 Pos : POSITION; float4 Colour : COLOR;

};
struct VS_IN
{
float4 Pos : POSITION;
};

struct PS_IN_UV
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float4 Colour : TEXCOORD1;


};
struct PS_IN
{
float4 Pos : POSITION; float4 Colour : TEXCOORD0;

};
struct PS_IN_SC_UV
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float4 Colour : TEXCOORD1;


};
struct PS_IN_SC
{
float4 Pos : POSITION; float4 Colour : TEXCOORD0;

};
