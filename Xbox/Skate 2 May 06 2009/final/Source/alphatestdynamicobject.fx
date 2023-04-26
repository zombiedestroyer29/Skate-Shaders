
half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half3 cSpecEccRefMask = GetSpecularEccentricityReflectionMaskValue ( i_specular , In.UV.xy );
half3 vViewDir = normalize ( g_vViewPos-In.vPos );

half3 vDetail = GetDetailNormalMapValue ( i_detail , In.UV.xy*In.dataconstants.y );
half3 vNormal = GetNormalMapValue ( i_normal , In.UV.xy );
half3 vND = ApplyDetailNormal ( vNormal , vDetail );
half3x3 matTBN = GetTangentMatrix ( In.vTangent , In.vBinormal , In.vNormal );
half3 wNormal = TransformToWorldFromTangent ( vND , matTBN );

half fShadowVal = CSM_ShadowMap_Self_PS ( float4 ( In.vPos, 1 ) , g_vViewPos , 1 , m_params[1].xyz );
half fWorldShadowVal = CalculateWorldShadow ( float4 ( In.vPos, 1 ) );

fShadowVal *= fWorldShadowVal;


half kd = GetTangentLight ( vND , half3 ( 0.64, 0.64, 0.420465 ) , TransformToTangentFromWorld ( g_vLightDir.xyz , matTBN ) );
half4 cDiffuseColour = cDiffuse;
half key_light = saturate ( dot ( wNormal , g_vLightDir.xyz ) );
half bounce_light = saturate ( dot ( wNormal , -reflect ( g_vLightDir.xyz , half3 ( 0, 1, 0 ) ) ) );
half4 lighting = half4 ( 0.3, 0.3, 0.4, 1.0 )*bounce_light+half4 ( 1, 1, 1, 1 )*key_light*fShadowVal+half4 ( 0.1, 0.1, 0.2, 1.0 );
half3 diffTerm = GetDiffuseTerm ( lighting , kd );

struct tSpecularTerm specTermParts;
half3 specTerm = GetSpecularTerm ( i_environment , g_vLightDir.xyz , wNormal , vViewDir , cSpecEccRefMask , fShadowVal , half3 ( 8.0, 1.0, 5.0 ) , 0.1 , half3 ( 18.0, 15.0, 10.5 ) , 290.0 , 10.0 , 1.5 , half3 ( 0.3, 4.0, 1.5 ) , specTermParts );


half4 outcolor = half4 ( diffTerm, 1 )*cDiffuseColour+half4 ( specTerm, 0 );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = cDiffuse.a;

return returncolour;
}

half4 shadowPS ( PS_IN_SIMPLE In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}
