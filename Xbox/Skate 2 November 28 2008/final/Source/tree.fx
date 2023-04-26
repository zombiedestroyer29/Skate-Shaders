
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
half4 cLightMap = GetLightMap_SingleTap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) );
cLightMap = max ( cLightMap , g_ViewDotLight.yyyy );
half3 cDiffuseColour = cDiffuse.rgb;
half3 diffTerm = cLightMap*g_ViewDotLight.x;
half4 outcolor = half4 ( diffTerm*cDiffuseColour, cDiffuse.a );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = cDiffuse.a;
return returncolour;
}
