
sampler i_detail = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_diffuse = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_specular = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
sampler i_normal = sampler_state { MinFilter = ANISOTROPIC; MagFilter = ANISOTROPIC; Mipfilter = LINEAR; MaxAnisotropy = 4; TrilinearThreshold = THREEEIGHTHS; };
samplerCUBE i_environment = sampler_state { AddressU = CLAMP; AddressV = CLAMP; AddressW = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR; Mipfilter = POINT; TrilinearThreshold = THREEEIGHTHS; };


float4 m_params [ 2 ];


float4 i_partArray [ 5*4 ];
float4 i_params [ 1 ];


struct VS_IN
{
float3 Pos : POSITION; float2 UV : TEXCOORD0; float3 vTangent : TANGENT; float3 vBinormal : BINORMAL;


};
struct PS_IN
{
float4 Pos : POSITION; float4 UV : TEXCOORD0; float3 vNormal : TEXCOORD1; float3 vTangent : TEXCOORD2; float3 vBinormal : TEXCOORD3; float3 vPos : TEXCOORD4; float4 Fog : TEXCOORD5; float4 dataconstants : TEXCOORD6;


};
struct PS_IN_SIMPLE
{
float4 Pos : POSITION;
};


half4x4 GetPartMatrix ( float4 partArray [ 5*4 ] , half index ) 
{
half index4 = index*4;
half4x4 partMatrix = half4x4 ( partArray[index4], partArray[index4+1], partArray[index4+2], partArray[index4+3] );


return partMatrix;
}


void defaultVS ( VS_IN In , out PS_IN Out ) 
{
half4x4 partMatrix = half4x4 ( i_partArray[0], i_partArray[1], i_partArray[2], i_partArray[3] );


half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , partMatrix ) );

Out.vBinormal = mul ( In.vBinormal , partMatrix );
Out.vTangent = mul ( In.vTangent , partMatrix );

Out.vNormal = GetNormal ( Out.vTangent , Out.vBinormal );
Out.vPos = P;

Out.Pos = mul ( P , g_matVP );


Out.UV = half4 ( In.UV.xy, 0.0f, 0.0f );

Out.Fog = ComputeFogFactor ( P , g_matV );
Out.dataconstants = half4 ( 0.0f, i_detailNormalUVScale.x, 0.0f, 0.0f );
}

void simpleVS ( VS_IN In , out PS_IN_SIMPLE Out ) 
{
half4x4 partMatrix = half4x4 ( i_partArray[0], i_partArray[1], i_partArray[2], i_partArray[3] );


half4 P = half4 ( mul ( half4 ( In.Pos, 1.0 ) , partMatrix ) );
Out.Pos = mul ( P , g_matVP );
}
