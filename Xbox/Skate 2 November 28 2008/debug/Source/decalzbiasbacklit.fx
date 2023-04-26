
void defaultVS ( VS_IN_BACKLIT In , out PS_IN Out ) 
{
float4 P = float4 ( In.Pos, 1.0 );
Out.vNormal = GetNormal ( In.vTangent , In.vBinormal );
Out.vBinormal = In.vBinormal.xyz;
Out.vTangent = In.vTangent.xyz;

Out.vPos = In.Pos.xyz;
Out.Pos = mul ( P , g_matVP );


Out.UV.xy = In.UV;
Out.UV.zw = abs ( In.LM );

Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );

half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vNormal , matTBN );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );

half NdotL = dot ( wNormal , g_vLightDir.xyz );
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , g_envattributes[1].xyz ) : 1.0;
half4 fShadowVal = GetShadowValue ( g_envattributes[0].rgba , shadow_inv_lerp );
half kd = GetTangentLight ( vNormal , g_envattributes[3].xyz , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 diffTerm = GetDiffuseTerm ( fShadowVal.rgb , kd );
half3 specTerm = GetCalculatedSpecularTerm ( g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , fShadowVal.a , g_envattributes[2].w , g_envattributes[3].w , g_envattributes[4].w , g_envattributes[5].xyz , ( g_envattributes[4].xyz*3 ) );


half4 outcolor = half4 ( diffTerm, 1 )*cDiffuse+half4 ( specTerm, 0 );

half3 black = half3 ( 0, 0, 0 );
half4 missingtexture = half4 ( black, cDiffuse.a );
outcolor = ChooseDebugLighting ( outcolor , diffTerm , black , specTerm , black , black , half3 ( kd, kd, kd ) , diffTerm+specTerm );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , missingtexture , missingtexture , cDiffuse , half4 ( cSpecEccRefMask.ggg, 1.0 ) , missingtexture , missingtexture , missingtexture , tex2D ( i_normal , In.UV.xy ) , half4 ( cSpecEccRefMask.bbb, 1.0 ) , half4 ( cSpecEccRefMask.rrr, 1.0 ) );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = cDiffuse.a;
return returncolour;
}
