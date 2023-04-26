
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
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , half3 ( -0.005, 10.0, 25.0 ) ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , g_lightmapLUTTexture , i_chromaticity , In.UV.zw , i_monoLightmap_Dot , half4 ( 4.5, 4.5, 4.5, 1.5 ) , half4 ( 0.07, 0.09, 0.1, 0.04 ) , 50.0 , shadow_inv_lerp );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
half3 vDetail = GetDetailNormalMapValue ( i_detail , In.UV.xy*In.dataconstants.y );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
half kd = GetTangentLight ( vND , half3 ( 0.64, 0.64, 0.420465 ) , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 cDiffuseColour = ApplyOverlay ( cOverlay , cDiffuse.rgb );
half3 diffTerm = GetDiffuseTerm ( cLightMap.rgb , kd );
struct tSpecularTerm specTermParts;
half3 vND = ApplyDetailNormal ( vNormal , vDetail );
half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , cLightMap.a , half3 ( 8.0, 1.0, 5.0 ) , 0.1 , half3 ( 30.0, 27.0, 21.0 ) , 290.0 , 10.0 , 1.5 , half3 ( 0.3, 4.0, 1.5 ) , specTermParts );
half NdotL = dot ( wNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , half3 ( -0.005, 10.0, 25.0 ) ) : 1.0;
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) , half4 ( 0.07, 0.09, 0.1, 0.04 ) , 50.0 , shadow_inv_lerp );
half NdotL = dot ( wNormal , g_vLightDir.xyz );
half4 outcolor = half4 ( diffTerm*cDiffuseColour+specTerm, 1 );
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) , half4 ( 0.07, 0.09, 0.1, 0.04 ) , 50.0 , shadow_inv_lerp );
half kd = GetTangentLight ( vND , half3 ( 0.64, 0.64, 0.420465 ) , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 cDiffuseColour = ApplyOverlay ( cOverlay , cDiffuse.rgb );
half3 diffTerm = GetDiffuseTerm ( cLightMap.rgb , kd );
struct tSpecularTerm specTermParts;
half3 cDiffuseColour = ApplyOverlay ( cOverlay , cDiffuse.rgb );
half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , cLightMap.a , half3 ( 8.0, 1.0, 5.0 ) , 0.1 , half3 ( 18.0, 15.0, 10.5 ) , 290.0 , 10.0 , 1.5 , half3 ( 0.3, 4.0, 1.5 ) , specTermParts );
struct tSpecularTerm specTermParts;

half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , cLightMap.a , half3 ( 8.0, 1.0, 5.0 ) , 0.1 , half3 ( 18.0, 15.0, 10.5 ) , 290.0 , 10.0 , 1.5 , half3 ( 0.3, 4.0, 1.5 ) , specTermParts );

half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor , In.Fog , g_envattributes[2].x*m_params[0].y ).rgb, 1 );
return returncolour;

}


half4 returncolour = half4 ( PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x ).rgb, 1 );
return returncolour;

}
return returncolour;

}
