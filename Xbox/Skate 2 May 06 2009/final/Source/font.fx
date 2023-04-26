
void FontVS ( VS_IN In , out PS_IN Out ) 
{
float4 pos = mul ( float4 ( In.Pos.xyz, 1.0f ) , i_matWorld );
Out.Pos = mul ( pos , g_matVP );
Out.UV = In.UV;
Out.Colour = i_colour;
}

half4 FontPS ( PS_IN In ) : COLOR 
{
half4 texcol = tex2D ( i_textureSampler , In.UV );
texcol *= In.Colour;
return texcol;
}

half4 Font8PS ( PS_IN In ) : COLOR 
{


return half4 ( In.Colour.r, In.Colour.g, In.Colour.b, tex2D ( i_textureSampler , In.UV ).a*In.Colour.a );

}
