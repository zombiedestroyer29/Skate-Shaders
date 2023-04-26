
void defaultVS ( VS_IN In , out PS_IN Out ) 
{

half4 P = half4 ( In.Pos, 1.0 );
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.UV;
Out.UV.zw = In.LM;
Out.Fog = ComputeFogFactor ( P , g_matV );
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 outcolor = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
half4 cLightMap = GetLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) );
outcolor *= lerp ( half4 ( 1, 1, 1, 1 ) , cLightMap , m_params[0].x );


half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = outcolor.a;
return returncolour;

}
