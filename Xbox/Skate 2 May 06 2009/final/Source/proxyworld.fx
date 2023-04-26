
void defaultVS ( VS_IN In , out PS_IN Out ) 
{


half4 P = half4 ( In.Pos, 1.0 );
Out.Pos = mul ( P , g_matVP );
Out.UV = In.UV;
Out.Fog = ComputeFogFactor ( P , g_matV );
}


half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 outcol = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );
return PS_Fog_Bloom_Tone ( outcol*m_params[0].y , In.Fog , g_envattributes[2].x );
}
