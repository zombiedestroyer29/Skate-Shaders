
float4 i_skyuvshift;


void defaultVS ( VS_IN In , out PS_IN Out ) 
{

float3 pos = In.Pos.xyz+g_vViewPos.xyz;

half4 P = half4 ( pos, 1.0 );
Out.Pos = mul ( P , g_matVP );

Out.UV = In.UV;

Out.vPos = In.Pos.xyz;
}

half4 defaultPS ( PS_IN In ) : COLOR 
{
half3 sky_detail = tex2D ( i_detail , In.UV.xy ).rgb;
half3 sky_gradient = tex2D ( i_diffuse , In.UV.xy ).rgb;
sky_gradient.rgb = lerp ( dot ( float3 ( .3, .59, .11 ) , sky_gradient.rgb ) , sky_gradient.rgb , m_params[1].w )*m_params[1].xyz.rgb;
half3 skycolour = sky_gradient+sky_detail-0.5;
skycolour = MoveToLinearSpaceRGB ( skycolour );

half dotPL = saturate ( dot ( normalize ( In.vPos.xyz ) , g_vLightDir ) );
half sinA = sqrt ( 1-dotPL*dotPL );
half s = sinA/m_params[0].x;
half4 sunClr = tex1D ( i_specular , s );
sunClr.rgb = MoveToLinearSpaceRGB ( sunClr.rgb );

half4 outcolor = half4 ( skycolour+( sunClr.rgb )/saturate ( sunClr.a+0.01f ), 1.0f );

half4 tonecol = PS_Bloom_Tone ( outcolor*m_params[0].y , g_envattributes[2].x );
tonecol.a = 1;
return tonecol;
}


void simpleVS ( VS_IN_SIMPLE In , out PS_IN_SIMPLE Out ) 
{

half4 P = mul ( half4 ( In.Pos, 1.0 ) , i_matWorld );
Out.Pos = mul ( P , g_matVP );
}

half4 simplePS ( PS_IN_SIMPLE In ) : COLOR 
{
return half4 ( 0, 0, 0, 1 );
}
