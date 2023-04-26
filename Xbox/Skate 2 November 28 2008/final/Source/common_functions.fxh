
float4 g_fPcaMean;
float4 g_fPcaWeightsR_0;
float4 g_fPcaWeightsR_1;
float4 g_fPcaWeightsG_0;
float4 g_fPcaWeightsG_1;
float4 g_fPcaWeightsB_0;
float4 g_fPcaWeightsB_1;

half3 GetPCANormal ( sampler n1 , sampler n2 , half2 uv , half tonedown ) 
{
half3 normalIn = half3 ( 0, 1, 0 );
half4 component0 = tex2D ( n1 , uv )*2-1;
half4 component1 = tex2D ( n2 , uv )*2-1;

half3 pcaNormal;
pcaNormal.x = g_fPcaMean.x+( dot ( component0 , g_fPcaWeightsR_0 )+dot ( component1 , g_fPcaWeightsR_1 ) );
pcaNormal.y = g_fPcaMean.y+( dot ( component0 , g_fPcaWeightsG_0 )+dot ( component1 , g_fPcaWeightsG_1 ) );
pcaNormal.z = g_fPcaMean.z+( dot ( component0 , g_fPcaWeightsB_0 )+dot ( component1 , g_fPcaWeightsB_1 ) );


pcaNormal = pcaNormal*2-1;


return normalize ( lerp ( normalIn , pcaNormal , tonedown ) );
}

half4 MoveToLinearSpace ( half4 color ) 
{
return color*color;
}

half3 MoveToLinearSpaceRGB ( half3 color ) 
{
return color*color;
}

half MoveToLinearSpaceHalf ( half color ) 
{
return color*color;
}


half3 GetNormal ( float3 InTangent , float3 InBinormal ) 
{
return cross ( InTangent , InBinormal );
}

half3 DecodeQuarterDirection ( half2 input ) 
{
const float two_power_0_25 = 1.1892071150;
const float two_power_0_50 = 1.4142135623;
const float two_power_1_50 = 2.8284271247;

input *= two_power_0_25;
float zz = two_power_1_50-dot ( input.xy , input.xy );
half3 dir = half3 ( input.xy, sqrt ( zz ) );
dir = dir.zzz*dir.xyz+half3 ( 0, 0, -two_power_0_50 );
dir = dir.zzz*dir.xyz+half3 ( 0, 0, -1 );
return dir;
}

void DecodeQuarterDirection_2 ( float4 input , out float3 vec1 , out float3 vec2 ) 
{
float2 zz;
const float two_power_0_25 = 1.1892071150;
const float two_power_0_50 = 1.4142135623;
const float two_power_1_50 = 2.8284271247;

input.xyzw *= two_power_0_25;
zz.x = dot ( input.xy , input.xy );
zz.y = dot ( input.zw , input.zw );
zz.xy = two_power_1_50.xx-zz.xy;

vec1 = half3 ( input.xy, sqrt ( zz.x ) );
vec1 = vec1.zzz*vec1.xyz+half3 ( 0, 0, -two_power_0_50 );
vec1 = vec1.zzz*vec1.xyz+half3 ( 0, 0, -1 );

vec2 = half3 ( input.zw, sqrt ( zz.y ) );
vec2 = vec2.zzz*vec2.xyz+half3 ( 0, 0, -two_power_0_50 );
vec2 = vec2.zzz*vec2.xyz+half3 ( 0, 0, -1 );

}


half3 DoubleVectorAngle ( half3 input ) 
{
return ( 2*input.zzz )*input.xyz+half3 ( 0, 0, -1 );
}

half3 DecodeQuarterDirection_SlowReference ( half2 compressed ) 
{
compressed /= sqrt ( 2 );
half3 result;
result.xy = compressed;
result.z = sqrt ( 1.0-( compressed.x*compressed.x )-( compressed.y*compressed.y ) );
result = DoubleVectorAngle ( result );
result = DoubleVectorAngle ( result );
return result;
}


float3 DecodeTangentBinormal ( half4 compressed , out float3 vBinormal , out float3 vTangent , float fix ) 
{


DecodeQuarterDirection_2 ( compressed , vTangent , vBinormal );

float3 normal = GetNormal ( vTangent , vBinormal );
half signbit = ( fix > =0 ) ? 1 : -1;
normal *= signbit;
return normal;
}
half3x3 GetTangentMatrix ( half3 tangent , half3 binormal , half3 normal ) 
{
return half3x3 ( tangent, binormal, normal );
}

half3 TransformToWorldFromTangent_normalize ( half3 incoming , half3x3 tbn ) 
{
return normalize ( mul ( incoming , tbn ) );
}

half3 TransformToWorldFromTangent ( half3 incoming , half3x3 tbn ) 
{
return normalize ( mul ( incoming , tbn ) );
}

half3 TransformToTangentFromWorld ( half3 incoming , half3x3 tbn ) 
{
return normalize ( mul ( tbn , incoming ) );
}

half CalculateSpecPower ( half specpow , half ecc ) 
{
return clamp ( 2*specpow*ecc , 5 , 1000 );
}
