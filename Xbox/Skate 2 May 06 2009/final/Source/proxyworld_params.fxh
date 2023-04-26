
float4x4 i_matWorld;
sampler i_diffuse;


float4 m_params [ 2 ];


float4 g_proxyClipXZ;


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0;

};


struct PS_IN
{
float4 Pos : POSITION; float2 UV : TEXCOORD0; float4 Fog : TEXCOORD1;


};

struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};
