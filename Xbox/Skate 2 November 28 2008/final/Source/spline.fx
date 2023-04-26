
void defaultVS ( VS_IN In , out PS_IN Out ) 
{
float t = frac ( In.Pos.x );
int input = floor ( In.Pos.x );

float4 blend;
blend.x = 1.0f;
blend.y = t;
blend.z = blend.y*t;
blend.w = blend.z*t;

float4 P = float4 ( 0, 0, 0, 0 );
float4 weight;
weight.x = dot ( blend , float4 ( 1.000000, -3.000000, 3.000000, -1.00000 ) );
weight.y = dot ( blend , float4 ( 4.000000, 0.000000, -6.000000, 3.000000 ) );
weight.z = dot ( blend , float4 ( 1.000000, 3.000000, 3.000000, -3.000000 ) );
weight.w = dot ( blend , float4 ( 0.000000, 0.000000, 0.000000, 1.000000 ) );

half4 wcp0 , wcp1 , wcp2 , wcp3;
wcp0 = mul ( i_cp[input+0] , i_matWorld );
wcp1 = mul ( i_cp[input+1] , i_matWorld );
wcp2 = mul ( i_cp[input+2] , i_matWorld );
wcp3 = mul ( i_cp[input+3] , i_matWorld );


P = wcp0*weight.x+wcp1*weight.y+wcp2*weight.z+wcp3*weight.w;
P *= 1.0f/6.0f;

P.w = 1.0f;
Out.Pos = mul ( P , g_matVP );
Out.UV.xy = In.Pos.yz;
float near_opacity = saturate ( ( Out.Pos.z-i_clipvalues.x )/i_clipvalues.y );
float far_opacity = 1.0f-saturate ( ( Out.Pos.z-i_clipvalues.z )/i_clipvalues.w );
Out.UV.z = min ( near_opacity , far_opacity );
Out.intensity = i_intensity;

}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half4 diffcolor = tex2D ( i_diffuse , In.UV.xy );
half3 outcolor = In.intensity.x*diffcolor.rgb/diffcolor.a;

half3 result = outcolor*In.UV.z;

return half4 ( result*result, 1.0f );
}

half4 darkenPS ( PS_IN In ) : COLOR 
{
half4 outcolor = In.intensity.y*tex2D ( i_diffuse , In.UV.xy );

half resultalpha = outcolor.a*In.UV.z;

return half4 ( outcolor.rgb*outcolor.rgb, resultalpha );
}
