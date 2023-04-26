
half3 GetSpecularEccentricityReflectionMaskValue ( sampler specular , float2 uv ) 
{
half3 cSpecEccRef = tex2D ( specular , uv ).xyz;
return cSpecEccRef;
}

half3 GetDetailNormalMapValue_normalize ( sampler normal , float2 uv ) 
{
half3 cNormal = tex2D ( normal , uv ).xyz;
return normalize ( 2.0*cNormal-1.0 );
}

half3 GetDetailNormalMapValue ( sampler normal , float2 uv ) 
{
half3 cNormal = tex2D ( normal , uv ).xyz;
return 2.0*cNormal-1.0;
}


half3 GetOverlayTextureValue ( sampler overlay , float2 uv , float opacity ) 
{
half3 cOverlay = tex2D ( overlay , uv );
half3 midvalue = half3 ( 0.5, 0.5, 0.5 );
return saturate ( ( cOverlay-midvalue )*opacity+midvalue );
}
half4 GetDecalTexture ( sampler decal , float2 uv ) 
{
half4 cDecal = tex2D ( decal , uv );
return half4 ( MoveToLinearSpaceRGB ( cDecal.rgb ), cDecal.a );
}

half3 ApplyDecal ( half4 decal , half3 base ) 
{
return lerp ( base , decal.rgb , decal.a );
}
half3 ApplyOverlay ( half3 overlay , half3 base ) 
{


half3 darken = 2*base*overlay;
return darken;
half3 lighten = 1-2*( 1-base )*( 1-overlay );
half3 rval;

rval = lerp ( darken , lighten , step ( base , 0.5 ) );
return rval;
}


half3 ApplyDetailNormal ( half3 normal , half3 detail ) 
{

return normalize ( normal+half3 ( detail.x, detail.y, 0 ) );
}
