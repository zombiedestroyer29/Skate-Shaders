
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float4 p = float4 ( In.Pos.xyz, 1.0 );
float4 uv = float4 ( In.UV.x, In.UV.y, 0.0, 1.0 );
float4 worldPos = mul ( mul ( p , i_matModelTarget ) , i_matModelView );

Out.Pos = mul ( worldPos , g_matVP );
Out.UV = mul ( uv , i_matTexture );
Out.Fog = ComputeFogFactor ( worldPos , g_matV );
}

float4 defaultPS ( PS_IN In ) : COLOR 
{
half4 cDiffuse = tex2D ( i_diffuse , In.UV );
half4 cStencil = tex2D ( i_stencil , In.UV );
half4 imposter = cDiffuse;

half4 colorized = imposter.x*i_colorize_red+imposter.z*i_colorize_blue;
imposter.xyz = ( ( 1.0-imposter.a )*colorized.xyz )+( imposter.a*imposter.xyz );

half exposure = 1.0;
half4 outcolor = PS_Fog_Bloom_Tone ( imposter , In.Fog , exposure );
outcolor.a = cStencil.b;
return outcolor;
}
