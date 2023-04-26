
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.pos, 1.0 );

Out.vNormal.xy = In.lm_norm.zw;
half2 signs = saturate ( half2 ( 65535, 65535 )*In.lm_norm.xy );
signs = signs*2-1;
float xy_len = min ( 0.999f , dot ( Out.vNormal.xy , Out.vNormal.xy ) );
Out.vNormal.z = signs.y*sqrt ( 1-xy_len );
Out.vPos = In.pos.xyz;
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.uv.xy;
Out.UV.zw = abs ( In.lm_norm.xy );
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
half3 vNormal = In.vNormal;


half NdotL = dot ( vNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , half3 ( -0.005, 10.0, 25.0 ) ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) , half4 ( 0.07, 0.09, 0.1, 0.04 ) , 50.0 , shadow_inv_lerp );


half3 diffTerm = GetDiffuseTerm ( cLightMap , 1 );

struct tSpecularTerm specTermParts;
half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , vNormal , vViewDir , cSpecEccRefMask , cLightMap.a , half3 ( 8.0, 1.0, 5.0 ) , 0.1 , half3 ( 18.0, 15.0, 10.5 ) , 290.0 , 10.0 , 1.5 , half3 ( 0.3, 4.0, 1.5 ) , specTermParts );


half4 outcolor = ( half4 ( diffTerm, 1 )*cDiffuse )*cDiffuse.a+half4 ( specTerm, 0 );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = outcolor.a;
return returncolour;
}

half4 CalculateIrradiance ( half3 N , float4 irradiance [ 9 ] ) 
{
half4 i = irradiance[0];

i += irradiance[1]*N.x;
i += irradiance[2]*N.y;
i += irradiance[3]*N.z;
i += irradiance[4]*( N.x*N.z );
i += irradiance[5]*( N.z*N.y );
i += irradiance[6]*( N.y*N.x );
i += irradiance[7]*( 3.0f*N.z*N.z-1.0f );
i += irradiance[8]*( N.x*N.x-N.y*N.y );

return i;
}

float3 irradcoeffs ( float3 L00 , float3 L1_1 , float3 L10 , float3 L11 , float3 L2_2 , float3 L2_1 , float3 L20 , float3 L21 , float3 L22 , float3 n ) 


{


float x2;
float y2;
float z2;
float xy;
float yz;
float xz;
float x;
float y;
float z;
float3 col;


const float c1 = 0.429043;
const float c2 = 0.511664;
const float c3 = 0.743125;
const float c4 = 0.886227;
const float c5 = 0.247708;
z = n[2];


z2 = z*z;
xz = x*z;


col = c1*L22*( x2-y2 )+c3*L20*z2+c4*L00-c5*L20+2*c1*( L2_2*xy+L21*xz+L2_1*yz )+2*c2*( L11*x+L1_1*y+L10*z );


return col;
}

void shVS ( VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.pos, 1.0 );

Out.vNormal.xy = In.lm_norm.zw;
half2 signs = saturate ( half2 ( 65535, 65535 )*In.lm_norm.xy );
signs = signs*2-1;
float xy_len = min ( 0.999f , dot ( Out.vNormal.xy , Out.vNormal.xy ) );
Out.vNormal.z = signs.y*sqrt ( 1-xy_len );
Out.vPos = In.pos.xyz;
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.uv.xy;
Out.UV.zw = abs ( In.lm_norm.xy );
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 shPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
half3 cCubeTex = GetCubeTextureValue ( i_environment , i_shmult[0].xyz ).rgb;

half3 finalColor = cDiffuse.xyz+cSpecEccRefMask+cCubeTex;

half3 wNormal = normalize ( In.vNormal );
half3 irradVal = CalculateIrradiance ( wNormal , i_shmult );

half4 vDiffuse = half4 ( irradVal, 1.0 )*half4 ( saturate ( finalColor+half3 ( 1, 1, 1 ) ), 1.0 );

half4 outcolor = half4 ( 0, 0, 0, 0 );
outcolor = PS_Fog_Bloom_Tone ( vDiffuse*m_params[0].y , In.Fog , g_envattributes[2].x );

return outcolor;
}
