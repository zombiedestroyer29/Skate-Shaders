
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.pos, 1.0 );

Out.vNormal.xy = In.lm_norm.zw;
half2 signs = saturate ( half2 ( 65535, 65535 )*In.lm_norm.xy );
signs = signs*2-1;
float xy_len = min ( 0.999f , dot ( Out.vNormal.xy , Out.vNormal.xy ) );
Out.vNormal.z = signs.y*sqrt ( 1-xy_len );
Out.vTangent = In.tangent;
Out.vBinormal = signs.x*cross ( Out.vNormal , Out.vTangent );
Out.vPos = In.pos.xyz;
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.uv_decal.xy;
Out.UV.zw = abs ( In.lm_norm.xy );
Out.Decal.xy = In.uv_decal.zw;
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.dataconstants = float4 ( i_macroOverlayUVScale.x, i_detailNormalUVScale.x, i_macroOverlayOpacity.x, i_diffuse2UVScale.x );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDecal = GetDecalTexture ( i_decal , In.Decal.xy );

half2 diffuse1uv = In.UV.xy;
half2 diffuse2uv = In.UV.xy*In.dataconstants.w;
half4 cDiffuse_Flat = GetDiffuseTextureValue ( i_diffuse , diffuse1uv );
half4 cDiffuse_Slope = GetDiffuseTextureValue ( i_diffuse2 , diffuse2uv );
half3 cOverlay = GetOverlayTextureValue ( i_macrooverlay , In.UV.xy*In.dataconstants.x , In.dataconstants.z );

half3 cSpecEccRefMask_Flat = GetSpecularEccentricityReflectionMaskValue ( i_specular , diffuse1uv );
half3 cSpecEccRefMask_Slope = GetSpecularEccentricityReflectionMaskValue ( i_specular , diffuse2uv );

half3 vNormal_Flat = GetNormalMapValue ( i_normal , diffuse1uv );
half3 vNormal_Slope = GetNormalMapValue ( i_normal2 , diffuse2uv );

half3 geo_normal = In.vNormal.xyz;
half blendN = 1-abs ( pow ( abs ( geo_normal.y ) , m_params[1].x )-m_params[1].y );
half3 vNormal = lerp ( vNormal_Flat , vNormal_Slope , blendN );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );

blendN = 1-abs ( pow ( abs ( wNormal.y ) , m_params[1].z )-m_params[1].w );
half3 cDiffuse = ApplyOverlay ( cOverlay , lerp ( cDiffuse_Flat , cDiffuse_Slope , blendN ) );
half3 cSpecEccRefMask = lerp ( cSpecEccRefMask_Flat , cSpecEccRefMask_Slope , blendN );

half3 vViewDir = normalize ( g_vViewPos-In.vPos );


half NdotL = dot ( wNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_envattributes[1].xyz ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) , g_envattributes[0].rgba , g_envattributes[2].z , shadow_inv_lerp );


half3 cDiffuseColour = ApplyDecal ( cDecal , cDiffuse );
half kd = GetTangentLight ( vNormal , g_envattributes[3].xyz , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 diffTerm = GetDiffuseTerm ( cLightMap , kd );
half3 specTerm = GetCalculatedSpecularTerm ( g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , cLightMap.a , g_envattributes[2].w , g_envattributes[3].w , g_envattributes[4].w , g_envattributes[5].xyz , ( g_envattributes[4].xyz*3 ) );


half4 outcolor = half4 ( diffTerm*cDiffuseColour+specTerm, 1 );

half3 black3 = half3 ( 0, 0, 0 );
half4 black4 = half4 ( black3, 1 );

outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , specTerm , black3 , black3 , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , cDecal , tex2D ( i_normal2 , diffuse2uv ) , half4 ( cDiffuse, 1 ) , half4 ( cSpecEccRefMask.ggg, 1.0 ) , black4 , half4 ( cLightMap.aaa, 1.0 ) , half4 ( cOverlay, 1 ) , tex2D ( i_normal , diffuse1uv ) , half4 ( cSpecEccRefMask.bbb, 1.0 ) , half4 ( cSpecEccRefMask.rrr, 1.0 ) );


outcolor = ChooseBNT ( outcolor , In.vBinormal , wNormal , In.vTangent );

half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = 1;
return returncolour;
}
