
struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0;

};

struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float4 Fog : TEXCOORD1;


};

sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; };


sampler i_stencil = sampler_state { MinFilter = LINEAR; MagFilter = LINEAR; Mipfilter = LINEAR; TrilinearThreshold = THREEEIGHTHS; AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; };


float4x4 i_matModelView;
float4x4 i_matModelTarget;
float4x4 i_matTexture;

float4 i_colorize_red;
float4 i_colorize_blue;
