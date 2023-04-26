
void defaultVS ( VS_IN_STATIC In , out PS_IN_STATIC Out ) 
{
half4 P = half4 ( In.Pos, 1.0 );
Out.Pos = mul ( P , g_matVP );
Out.vPos = In.Pos.xyz;


Out.UV.xy = In.UV;
Out.UV.zw = abs ( In.LM );
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN_STATIC In ) : COLOR 
{
half4 uv = GetAnimatedUV ( half4 ( m_params[2].xy, m_params[2].zw ) , half4 ( m_params[1].xy, m_params[1].zw ) , In.UV.xy*m_params[3].x );
half3 pcaNormal = GetPCANormal ( i_normal , i_normal2 , uv.zw , m_params[0].z );
half3 difUVOffset = GetPCANormal ( i_normal , i_normal2 , uv.xy , m_params[0].w );
half2 diffUV = In.UV.xy+0.02*difUVOffset.xz;
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , diffUV );
half3 cSpecEccRefMask = saturate ( GetSpecularEccentricityReflectionMaskValue ( i_specular , diffUV )-m_params[3].y );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );


half NdotL = dot ( pcaNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , half3 ( -0.005, 10.0, 25.0 ) ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw+0.01*pcaNormal.xz , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) , half4 ( 0.07, 0.09, 0.1, 0.04 ) , 50.0 , shadow_inv_lerp );


half kd = GetTangentLight ( pcaNormal , half3 ( 0.64, 0.64, 0.420465 ) , g_vLightDir.xyz );
half3 diffTerm = GetDiffuseTerm ( cLightMap.rgb , kd );
struct tSpecularTerm specTermParts;


half reflection_luminosity = 0.3*saturate ( 4.0*( cSpecEccRefMask.b-1.5 ) );
half3 reflected = cSpecEccRefMask.b*GetReflectionTerm ( i_environment , pcaNormal , vViewDir , cLightMap.a , reflection_luminosity )*1.5;


half ks = phong_specular ( pcaNormal , vViewDir , g_vLightDir.xyz , m_params[3].z );
half3 calculated = cSpecEccRefMask.r*ks*half3 ( 18.0, 15.0, 10.5 )*saturate ( cLightMap.a-0.1 );


half3 specTerm = ( calculated+reflected );


half4 outcolor = half4 ( diffTerm, 1 )*cDiffuse+half4 ( specTerm, 0 );


half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x ).rgb, 1 );
return returncolour;
}
