
float4 i_uAnimationSpeed;
float4 i_vAnimationSpeed;
float4 g_fAnimationTime;

void defaultVS ( VS_IN In , out PS_IN Out ) 
{

half4 P = half4 ( In.Pos, 1.0 );
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.UV+g_fAnimationTime.xx*half2 ( i_uAnimationSpeed.x, i_vAnimationSpeed.x );
Out.UV.zw = In.LM;
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 outcol = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );

half4 cLightMap = GetLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) );
outcol *= lerp ( half4 ( 1, 1, 1, 1 ) , cLightMap , m_params[0].x );


half4 returncolour = PS_Fog_Bloom_Tone ( outcol*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = 0;
return returncolour;
}
