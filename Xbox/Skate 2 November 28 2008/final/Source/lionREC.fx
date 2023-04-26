
half2 ComputeFogFactor ( half4 worldPos , half4 viewPos ) 
{
return half2 ( worldPos.y, length ( viewPos.xz ) );
}

void RenderVS ( VS_IN In , out PS_IN Out ) 
{
Out.ProjPos = mul ( half4 ( In.ObjPos, 1 ) , g_matVP );
Out.UVFog.xy = In.UV;
Out.Color = In.Color;
Out.UVFog.zw = half2 ( 0.0, 0.0 );
}

half4 RenderPS ( PS_IN In ) : COLOR 
{
half4 vColor = tex2D ( i_textureSampler , In.UVFog.xy );
half4 outcol = vColor*In.Color;

return outcol;
}
