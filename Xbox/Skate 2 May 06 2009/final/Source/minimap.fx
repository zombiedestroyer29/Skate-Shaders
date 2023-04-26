
void VtxShader ( VS_IN In , out PS_IN Out ) 
{
Out.Pos = mul ( half4 ( In.Pos.xyz, 1.0f ) , g_matVP );
Out.ScreenPos = In.Pos.xy;
Out.UV = In.UV;
}
half4 PixShader ( PS_IN In ) : COLOR 
{
half2 posDiff = In.ScreenPos-i_params.xy;
half radius = i_params.z;
half nonFeatheredDistance = i_params.w;

half distance = sqrt ( ( posDiff.x*posDiff.x )+( posDiff.y*posDiff.y ) );

half alphaAdjust = 1.0f-smoothstep ( nonFeatheredDistance , radius , distance );
return tex2D ( i_textureSampler , In.UV )*half4 ( i_colour.rgb, i_colour.a*alphaAdjust );
}
