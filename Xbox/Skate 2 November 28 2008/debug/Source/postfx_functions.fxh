
float HDR_exposure = 0.5f;

half Fog ( half fogfactor , half4 min_taper_max_power ) 
{
float fog = saturate ( ( fogfactor-min_taper_max_power.x )*min_taper_max_power.y );
fog = saturate ( pow ( fog , min_taper_max_power.w ) );

return min ( fog , min_taper_max_power.z );
}

float4 g_FogK1;
float4 g_FogColour;

half4 ComputeFogFactor ( half4 Pos , float4x4 matV ) 
{
half4 Out;

float3 viewdir = Pos.xyz-g_vViewPos.xyz;
float dist = length ( viewdir );

float f1 = saturate ( ( dist*g_FogK1.x )+g_FogK1.y );
f1 = pow ( f1 , g_FogK1.z );

Out.rgba = ( g_FogColour*f1 )+float4 ( 0, 0, 0, 1 );
return Out;
}


half4 MoveFromLinearSpace ( half4 color ) 
{


return sqrt ( color );

}


half4 tonemap ( half4 x ) 
{
half4 ret;

ret = saturate ( half4 ( 1, 1, 1, 1 )-x );
ret *= ret;
ret = max ( ( x*0.25 )+0.75 , half4 ( 1, 1, 1, 1 ) )-ret;
return ret*0.5;
}


half4 PS_Bloom_Tone ( half4 FinalCol , half exposure ) 
{

half4 tonecol = FinalCol*exposure;
tonecol = tonemap ( tonecol );
return MoveFromLinearSpace ( tonecol );
}

half4 PS_Bloom ( half4 FinalCol , half exposure ) 
{

half4 tonecol = FinalCol*exposure;
return tonemap ( tonecol );
}

half4 PS_Fog_Bloom_Tone ( half4 FinalCol , half4 FogFactor , half exposure ) 
{

half4 tonecol = ( FinalCol*FogFactor.a+FogFactor.rgba )*exposure;
tonecol = tonemap ( tonecol );

return MoveFromLinearSpace ( tonecol );
}

half4 PS_Fog_Bloom ( half4 FinalCol , half4 FogFactor , half exposure ) 
{

half4 tonecol = ( FinalCol*FogFactor.a+FogFactor.rgba )*exposure;
return tonemap ( tonecol );

}
