
float4x4 i_matWorld;
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };

float4 g_TrafficLightsStatus_2;
float4 g_TrafficLightsStatus_1;


float4 m_params [ 1 ];


struct VS_IN
{
float3 pos : POSITION; float4 uv1_lookup : TEXCOORD0; float2 uv2 : TEXCOORD1;


};
struct PS_IN
{
float4 Pos : POSITION; float2 uv : TEXCOORD0; float4 Fog : TEXCOORD1;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};

bool TrafficLightStateLookup ( half2 lookUpUV , half4 vTrafficLightsStatus ) 
{
const int lookUpColorVectorIndex = floor ( lookUpUV.x*4.0f );

half stateVal = 0.0f;

if ( lookUpColorVectorIndex == 0 ) stateVal = vTrafficLightsStatus.x; else 
if ( lookUpColorVectorIndex == 1 ) stateVal = vTrafficLightsStatus.y; else 
if ( lookUpColorVectorIndex == 2 ) stateVal = vTrafficLightsStatus.z; else 
 if ( lookUpColorVectorIndex == 3 ) stateVal = vTrafficLightsStatus.w;

return ( stateVal > 1.0f );
}
