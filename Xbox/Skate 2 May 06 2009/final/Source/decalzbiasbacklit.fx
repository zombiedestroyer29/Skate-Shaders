
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
half shadow_inv_lerp = ( NdotL > 0.0 ) ? CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , half3 ( -0.005, 10.0, 25.0 ) ) : 1.0;
half4 fShadowVal = GetShadowValue ( half4 ( 0.07, 0.09, 0.1, 0.04 ) , shadow_inv_lerp );
half kd = GetTangentLight ( vNormal , half3 ( 0.64, 0.64, 0.420465 ) , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half3 diffTerm = GetDiffuseTerm ( fShadowVal.rgb , kd );
half3 specTerm = GetCalculatedSpecularTerm ( g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , fShadowVal.a , 0.1 , 290.0 , 10.0 , half3 ( 8.0, 1.0, 5.0 ) , half3 ( 18.0, 15.0, 10.5 ) );


half4 outcolor = half4 ( diffTerm, 1 )*cDiffuse+half4 ( specTerm, 0 );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = cDiffuse.a;
return returncolour;
}
