
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
half4 P = mul ( half4 ( In.Pos, 1.0 ) , i_matWorld );
half4 N = mul ( half4 ( In.vNormal, 0.0f ) , i_matWorld );
Out.Pos = mul ( P , g_matVP );

Out.UV.xy = In.UV;
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 diffuse = GetDiffuseTextureValue ( i_diffuse , In.UV.xy );

half4 outcol = PS_Fog_Bloom_Tone ( diffuse*i_colortint*m_params[0].y , In.Fog , g_envattributes[2].x );
outcol.a = diffuse.a*i_colortint.a;
return outcol;
}
