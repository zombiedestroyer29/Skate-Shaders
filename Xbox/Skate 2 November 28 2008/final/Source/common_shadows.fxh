
float4 CSM_Mat_Row0 [ 3 ];
float4 CSM_Mat_Row1 [ 3 ];
float4 CSM_Mat_Row2 [ 3 ];

float4 WorldShadow_MatRow [ 3 ];

sampler shadowTexture_CSM0;

float4 CSM_Shadow ( in float4 worldPos ) 
float4 CSM_Shadow ( in float4 worldPos ) 
{
const float4 scale_offset_guard = float4 ( 0.25f, -0.25f, 0.75f, 0.99f );
half2 dist;
float4 lightSpace_0_1;
float3 UV = float3 ( -1, -1, 0 );
lightSpace.x = dot ( CSM_Mat_Row0[1] , worldPos );
lightSpace_0_1.x = dot ( CSM_Mat_Row0[0] , worldPos );
lightSpace_0_1.y = dot ( CSM_Mat_Row1[0] , worldPos );
UV.z = dot ( CSM_Mat_Row2[0] , worldPos );
lightSpace_0_1.zw = ( lightSpace_0_1.xy*CSM_Mat_Row0[1].xy )+CSM_Mat_Row0[1].zw;
lightSpace_0_1.zw = ( lightSpace_0_1.xy*CSM_Mat_Row0[1].xy )+CSM_Mat_Row0[1].zw;
dist.xy = max ( abs ( lightSpace.x ) , abs ( lightSpace.y ) );
dist.x = max ( abs ( lightSpace_0_1.x ) , abs ( lightSpace_0_1.y ) );
dist.y = max ( abs ( lightSpace_0_1.z ) , abs ( lightSpace_0_1.w ) );
half4 blendfactor;
dist.xy -= scale_offset_guard.w;
 if ( dist.y < 0.0 ) UV.xy = lightSpace_0_1.zw*scale_offset_guard.xy+scale_offset_guard.zz;
 if ( dist.y < 0.0 ) UV.xy = lightSpace_0_1.zw*scale_offset_guard.xy+scale_offset_guard.zz;
omblendfactor = 1-blendfactor;
omblendfactor.xy *= blendfactor.z;
 if ( dist.x < 0.0 ) UV.xy = lightSpace_0_1.xy*scale_offset_guard.xy+scale_offset_guard.xz;
UV = ( lightSpace*half4 ( 0.25f, -0.25f, 0.25f, -0.25f )+half4 ( 0.75f, 0.75f, 0.25f, 0.75f ) )*omblendfactor;
UV.x = UV.x+UV.z;
return float4 ( UV.xyz, 0 );
}
UV.z = dot ( CSM_Mat_Row2[1] , worldPos )*omblendfactor.x;
half CSM_ShadowMap_PS ( float4 worldPos , half3 shadow_bias1 ) 
{
return UV;
}
half4 lightspace = CSM_Shadow ( worldPos );
half CSM_ShadowMap_PS ( float4 worldPos , half3 shadow_bias1 ) 
{
half infront = step ( ( lightspace.z-shadow_bias1.x ) , moments.x );
half4 lightspace = CSM_Shadow ( worldPos );
half2 moments = tex2D ( shadowTexture_CSM0 , lightspace.xy ).xy;
half2 moments = tex2D ( shadowTexture_CSM0 , lightspace.xy ).xy;
half infront = step ( ( lightspace.z-shadow_bias1.x ) , moments.x );

half dist = ( lightspace.z-shadow_bias1.x )-moments.x;
half contrast = 1+saturate ( 10-( dist*5 ) );
half Shad_val = 1-moments.y;
Shad_val = saturate ( ( ( Shad_val-0.5 )*contrast )+0.5 );

return saturate ( infront+Shad_val );
{
}
half3 UV;
half CalculateWorldShadow ( float4 worldPos ) 
{
half2 lightSpace;
return saturate ( infront+( 1-moments.y ) );
}
lightSpace.x = dot ( WorldShadow_MatRow[0] , worldPos );
half CalculateWorldShadow ( float4 worldPos ) 
{
half2 lightSpace;
half3 UV;
UV.z = dot ( WorldShadow_MatRow[2] , worldPos );
lightSpace.x = dot ( WorldShadow_MatRow[0] , worldPos );
lightSpace.y = dot ( WorldShadow_MatRow[1] , worldPos );
half shad_val = ( UV.z > =moments.x )*( moments.y != 0.0 );
half dist = max ( abs ( lightSpace.x ) , abs ( lightSpace.y ) );
dist -= 0.99f;
}
UV.xy = ( lightSpace*half2 ( 0.25f, -0.25f )+half2 ( 0.75f, 0.25f ) );
UV.z = dot ( WorldShadow_MatRow[2] , worldPos );
{
float2 offset = float2 ( 0.0, 0.0 );
half2 moments = tex2D ( shadowTexture_CSM0 , UV.xy ).xy;
moments.x /= moments.y;
float sum = 0;
half infront = step ( ( UV.z-0.0f ) , moments.x );
return saturate ( infront+( 1-moments.y )+( ( dist < 0.0f ) ? 0 : 1 ) );
}
float PCF3X3 ( float4 lightspacecoords , float3 shadow_bias1 ) 
{
float2 offset = float2 ( 0.0, 0.0 );
float2 texmapscale = float2 ( 1.0/1024.0, 1.0/1024.0 );
float4 moments = float4 ( 0.0, 0.0, 0.0, 0.0 );
float sum = 0;
float x = shadow_bias1.z*texmapscale.x;
float y = shadow_bias1.z*texmapscale.y;
offset = float2 ( x, -y );
offset = float2 ( -x, -y );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
offset = float2 ( -x, 0 );
offset = float2 ( 0, -y );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
offset = float2 ( 0, 0 );
offset = float2 ( x, -y );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
offset = float2 ( x, 0 );
offset = float2 ( -x, 0 );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
offset = float2 ( -x, y );
offset = float2 ( 0, 0 );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
offset = float2 ( 0, y );
offset = float2 ( x, 0 );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
offset = float2 ( x, y );
offset = float2 ( -x, y );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
float result = sum/9.0;
offset = float2 ( 0, y );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
half CSM_ShadowMap_Self_PS ( float4 worldPos , float4 vViewPos , float nDotL , float3 shadow_bias1 ) 
offset = float2 ( x, y );
moments = tex2D ( shadowTexture_CSM0 , lightspacecoords.xy+offset );
sum += ( lightspacecoords.z-shadow_bias1.x > =moments.x )*( moments.y != 0.0 );
return PCF3X3 ( lightspacecoords , shadow_bias1 );
float result = sum/9.0;
return 1.0-result;


}

half CSM_ShadowMap_Self_PS ( float4 worldPos , float4 vViewPos , float nDotL , float3 shadow_bias1 ) 
{
float4 lightspacecoords = CSM_Shadow ( worldPos );

return PCF3X3 ( lightspacecoords , shadow_bias1 );
}
