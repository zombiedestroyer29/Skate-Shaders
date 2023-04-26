
void optimizedVS ( OPT_VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.pos, 1.0 );

Out.vNormal.xy = In.lm_norm.zw;
half2 signs = saturate ( half2 ( 65535, 65535 )*In.lm_norm.xy );
signs = signs*2-1;
Out.vNormal.z = signs.y*sqrt ( 1-dot ( Out.vNormal.xy , Out.vNormal.xy ) );
Out.vBinormal = In.binormal;
Out.vTangent = cross ( Out.vNormal , Out.vBinormal );
Out.vNormal *= signs.x;
Out.vPos = In.pos.xyz;
Out.Pos = mul ( P , g_matVP );
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.UV.xy = In.uv;
Out.UV.zw = abs ( In.lm_norm.xy );
Out.Fog = ComputeFogFactor ( P , g_matV );
}
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 P = float4 ( In.Pos, 1.0 );
half4 outcolor = half4 ( cDiffuseColour, 1 );
Out.vNormal = DecodeTangentBinormal ( In.vTangent , Out.vBinormal , Out.vTangent , In.LM.x );
half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x ).rgb, 1 );
return returncolour;
half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x ).rgb, 1 );
}

Out.vPos = In.Pos.xyz;
Out.Pos = mul ( P , g_matVP );
float4 P = float4 ( In.pos, 1.0 );
Out.UV.xy = In.UV;
Out.UV.zw = abs ( In.LM );
Out.Fog = ComputeFogFactor ( P , g_matV );
}
Out.vNormal.z = signs.y*sqrt ( 1-dot ( Out.vNormal.xy , Out.vNormal.xy ) );
float4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cOverlay = GetOverlayTextureValue ( i_macrooverlay , In.UV.xy*i_macroOverlayUVScale.x , i_macroOverlayOpacity.x );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
cSpecEccRefMask = ApplyOverlay ( cOverlay , cSpecEccRefMask );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );
Out.Fog = ComputeFogFactor ( P , g_matV );
half3 vDetail = GetDetailNormalMapValue ( i_detail , In.UV.xy*i_detailNormalUVScale.x );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
}
half3 vND = ApplyDetailNormal ( vNormal , vDetail );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent_normalize ( vND , matTBN );
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cOverlay = GetOverlayTextureValue ( i_macrooverlay , In.UV.xy*In.dataconstants.x , In.dataconstants.z );
half NdotL = dot ( wNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_envattributes[1].xyz ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , g_lightmapLUTTexture , i_chromaticity , In.UV.zw , i_monoLightmap_Dot , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) , g_envattributes[0].rgba , g_envattributes[2].z , shadow_inv_lerp );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
half3 vDetail = GetDetailNormalMapValue ( i_detail , In.UV.xy*In.dataconstants.y );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
half kd = GetTangentLight ( vND , g_envattributes[3].xyz , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 cDiffuseColour = ApplyOverlay ( cOverlay , cDiffuse.rgb );
half3 diffTerm = GetDiffuseTerm ( cLightMap.rgb , kd );
struct tSpecularTerm specTermParts;
half3 vND = ApplyDetailNormal ( vNormal , vDetail );
half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , cLightMap.a , g_envattributes[5].xyz , g_envattributes[2].w , ( g_envattributes[4].xyz*3 ) , g_envattributes[3].w , g_envattributes[4].w , g_envattributes[5].w , g_envattributes[6].yzw , specTermParts );
half NdotL = dot ( wNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_envattributes[1].xyz ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) , g_envattributes[0].rgba , g_envattributes[2].z , shadow_inv_lerp );
half NdotL = dot ( wNormal , g_vLightDir.xyz );
half4 outcolor = half4 ( diffTerm*cDiffuseColour+specTerm, 1 );
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) , g_envattributes[0].rgba , g_envattributes[2].z , shadow_inv_lerp );
half3 black3 = half3 ( 0, 0, 0 );
half4 black4 = half4 ( black3, 1 );
half3 diffTerm = GetDiffuseTerm ( cLightMap.rgb , kd );
struct tSpecularTerm specTermParts;
outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , specTermParts.calculated , black3 , specTermParts.reflected , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , black4 , tex2D ( i_detail , In.UV.xy*i_detailNormalUVScale.x ) , cDiffuse , half4 ( cSpecEccRefMask.ggg, 1.0 ) , GetDebugReflectClr ( i_environment , wNormal , vViewDir ) , half4 ( cLightMap.aaa, 1.0 ) , half4 ( cOverlay, 1 ) , tex2D ( i_normal , In.UV.xy ) , half4 ( cSpecEccRefMask.bbb, 1.0 ) , half4 ( cSpecEccRefMask.rrr, 1.0 ) );
struct tSpecularTerm specTermParts;

outcolor = ChooseBNT ( outcolor , In.vBinormal , wNormal , In.vTangent );

half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor , In.Fog , g_envattributes[2].x*m_params[0].y ).rgb, 1 );
return returncolour;
half3 black3 = half3 ( 0, 0, 0 );
}

half3 black3 = half3 ( 0, 0, 0 );
outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , specTermParts.calculated , black3 , specTermParts.reflected , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , black4 , tex2D ( i_detail , In.UV.xy*In.dataconstants.y ) , cDiffuse , half4 ( cSpecEccRefMask.ggg, 1.0 ) , GetDebugReflectClr ( i_environment , wNormal , vViewDir ) , half4 ( cLightMap.aaa, 1.0 ) , half4 ( cOverlay, 1 ) , tex2D ( i_normal , In.UV.xy ) , half4 ( cSpecEccRefMask.bbb, 1.0 ) , half4 ( cSpecEccRefMask.rrr, 1.0 ) );

outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , specTermParts.calculated , black3 , specTermParts.reflected , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseBNT ( outcolor , In.vBinormal , wNormal , In.vTangent );

half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x ).rgb, 1 );
return returncolour;

}
return returncolour;

}
