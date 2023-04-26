
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
Out.UV.xy = In.uv;
Out.UV.zw = abs ( In.lm_effectuv );


half3 uvscale = half3 ( In.lm_effectuv.zw, In.lm_effectuv.z+In.lm_effectuv.w )-half3 ( 0.5f, 0.5f, 1.0f );
half3 wave_time = g_fAnimationTime.xxx-uvscale;
half3 animationscale = uvscale*half3 ( m_params[0].w, m_params[1].w, m_params[2].w );
half3 move = sin ( wave_time*m_params[1].xyz+m_params[2].xyz )*animationscale;
half4 P = float4 ( In.pos+move, 1.0 );
Out.Pos = mul ( P , g_matVP );
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


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor , In.Fog , g_envattributes[2].x );
returncolour.a = cDiffuse.a;
return returncolour;
}
