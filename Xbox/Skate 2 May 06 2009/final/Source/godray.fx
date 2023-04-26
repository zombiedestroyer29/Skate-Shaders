
void defaultVS ( VS_IN In , out PS_IN Out ) 
{

half4 P = mul ( half4 ( In.pos, 1.0 ) , i_matWorld );

Out.Pos = mul ( P , g_matVP );
Out.UV = half4 ( In.uv, In.lm );
Out.vNormal = In.normal;
Out.vPos = P.xyz;
Out.lightmapchannel = i_monoLightmap_Dot;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = tex2D ( i_diffuse , In.UV.xy );

half4 cLightMap = GetLightMap ( i_lightmap , i_chromaticity , In.UV.zw , In.lightmapchannel , half4 ( 4.5, 4.5, 4.5, 1.5 ) );

half4 outcolor = cDiffuse*cLightMap;
float viewangle = abs ( dot ( In.vNormal , normalize ( g_vViewPos-In.vPos ) ) );
half4 returncolour = half4 ( ( viewangle*outcolor ).rgb, 0 );
return returncolour;

}
