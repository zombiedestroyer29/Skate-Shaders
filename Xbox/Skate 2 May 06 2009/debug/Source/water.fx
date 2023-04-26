
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
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_envattributes[1].xyz ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw+0.01*pcaNormal.xz , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) , g_envattributes[0].rgba , g_envattributes[2].z , shadow_inv_lerp );


half kd = GetTangentLight ( pcaNormal , g_envattributes[3].xyz , g_vLightDir.xyz );
half3 diffTerm = GetDiffuseTerm ( cLightMap.rgb , kd );
struct tSpecularTerm specTermParts;


half reflection_luminosity = g_envattributes[6].y*saturate ( g_envattributes[6].z*( cSpecEccRefMask.b-g_envattributes[6].w ) );
half3 reflected = cSpecEccRefMask.b*GetReflectionTerm ( i_environment , pcaNormal , vViewDir , cLightMap.a , reflection_luminosity )*g_envattributes[5].w;


half ks = phong_specular ( pcaNormal , vViewDir , g_vLightDir.xyz , m_params[3].z );
half3 calculated = cSpecEccRefMask.r*ks*( g_envattributes[4].xyz*3 )*saturate ( cLightMap.a-g_envattributes[2].w );


specTermParts.masks = cSpecEccRefMask;
specTermParts.calculated = calculated;
specTermParts.reflected = reflected;

half3 specTerm = ( calculated+reflected );


half4 outcolor = half4 ( diffTerm, 1 )*cDiffuse+half4 ( specTerm, 0 );

half3 black3 = half3 ( 0, 0, 0 );
half4 black4 = half4 ( black3, 1 );


outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , specTermParts.calculated , black3 , specTermParts.reflected , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , black4 , tex2D ( i_normal2 , In.UV.xy ) , cDiffuse , half4 ( cSpecEccRefMask.ggg, 1.0 ) , GetDebugReflectClr ( i_environment , pcaNormal , vViewDir ) , half4 ( cLightMap.aaa, 1.0 ) , black4 , tex2D ( i_normal , In.UV.xy ) , half4 ( cSpecEccRefMask.bbb, 1.0 ) , half4 ( cSpecEccRefMask.rrr, 1.0 ) );


half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x ).rgb, 1 );
return returncolour;
}
