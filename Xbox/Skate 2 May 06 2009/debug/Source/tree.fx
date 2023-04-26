
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
half4 P = float4 ( In.Pos, 1.0 );
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.UV;
Out.UV.zw = abs ( In.LM );

Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half4 cLightMap = GetLightMap_SingleTap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , ( g_envattributes[1].w*half4 ( 3.0, 3.0, 3.0, 1.0 ) ) );
cLightMap = max ( cLightMap , g_ViewDotLight.yyyy );
half3 cDiffuseColour = cDiffuse.rgb;
half3 diffTerm = cLightMap*g_ViewDotLight.x;
half4 outcolor = half4 ( diffTerm*cDiffuseColour, cDiffuse.a );


half3 black3 = half3 ( 0, 0, 0 );
half4 black4 = half4 ( black3, cDiffuse.a );
outcolor = ChooseDebugLighting ( outcolor , diffTerm , cLightMap.rgb , black3 , black3 , black3 , black3 , cLightMap.rgb );
outcolor = ChooseDebugTexture ( outcolor , tex2D ( i_chromaticity , In.UV.zw ) , black4 , black4 , cDiffuse , black4 , black4 , half4 ( cLightMap.aaa, 1.0 ) , black4 , black4 , black4 , black4 );


outcolor = ChooseBNT ( outcolor , black3 , black3 , black3 );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = cDiffuse.a;
return returncolour;
}
