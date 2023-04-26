
void defaultVS ( VS_IN In , out PS_IN Out ) 
{

float4 P = float4 ( In.pos, 1.0 );
Out.Pos = mul ( P , g_matVP );


if ( TrafficLightStateLookup ( In.uv1_lookup.zw , g_TrafficLightsStatus_2 ) ) {

Out.uv = In.uv2.xy;
} else {


Out.uv = In.uv1_lookup.xy;
}
Out.Fog = ComputeFogFactor ( P , g_matV );
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 outcolor = tex2D ( i_diffuse , In.uv );
half4 returncolour = PS_Fog_Bloom_Tone ( outcolor*m_params[0].y , In.Fog , g_envattributes[2].x );
returncolour.a = outcolor.a;
return returncolour;
}
