
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
half4 P = half4 ( In.Pos, 1.0 );
Out.vPos = P;
Out.Pos = mul ( P , g_matVP );
Out.UV.xy = In.UV;
Out.UV.zw = In.LM;
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );


half shadow_inv_lerp = CSM_ShadowMap_PS ( float4 ( In.vPos, 1 ) , half3 ( -0.005, 10.0, 25.0 ) );
half4 cLightMap = GetShadowedLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) , half4 ( 0.07, 0.09, 0.1, 0.04 ) , 50.0 , shadow_inv_lerp );


half4 fog_near_taper_max_power = half4 ( g_locattributes[1].y, g_locattributes[1].w, g_locattributes[1].x, g_locattributes[1].z );
half4 outcolor = half4 ( cDiffuse.rgb*cLightMap, cDiffuse.a );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = outcolor.a;
return returncolour;


}
