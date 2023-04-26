
half4 GetDiffuseTextureValue ( sampler diffuse , float2 uv ) 
{
half4 cDiffuse = tex2D ( diffuse , uv );
cDiffuse.rgb = MoveToLinearSpaceRGB ( cDiffuse.rgb );
return cDiffuse;
}
half4 GetDiffuseTextureValue_Character ( sampler diffuse , float2 uv ) 
{
half4 cDiffuse = tex2D ( diffuse , uv );
return MoveToLinearSpace ( cDiffuse );
}
half4 GetCubeTextureValue ( samplerCUBE colorCube , half3 luVec ) 
{
half4 cColorCube = texCUBE ( colorCube , luVec );
half GetSpecularMaskValue ( sampler specular , float2 uv ) 
return MoveToLinearSpace ( cColorCube );
}
return MoveToLinearSpace ( cSpecular );
half GetSpecularMaskValue ( sampler specular , float2 uv ) 
{
half4 cSpecular = tex2D ( specular , uv ).x;
return MoveToLinearSpace ( cSpecular );
}
return normal*m;
half3 InvertNormalMap ( half3 normal , float fix ) 
{
float m = sign ( fix+0.0001 );
return normal*m;
}
return normalize ( 2.0f*cNormal-1.0f );
half3 GetNormalMapValue_normalize ( sampler normal , float2 uv ) 
{
half3 cNormal = tex2D ( normal , uv ).xyz;
return normalize ( 2.0f*cNormal-1.0f );
}
half3 cNormal = tex2D ( normal , uv ).xyz;
return 2.0f*cNormal-1.0f;
half3 GetNormalMapValue ( sampler normal , float2 uv ) 
{
half3 cNormal = tex2D ( normal , uv ).xyz;
return 2.0f*cNormal-1.0f;
}
half3 cNormal = half3 ( 0, 0, 0 );
half3 GetDXNNormalMapValue ( sampler normal , float2 uv ) 
{
half2 cNormal1 = tex2D ( normal , uv ).ag;
cNormal1 = 2.0f*cNormal1-1.0f;

half3 cNormal = half3 ( 0, 0, 0 );
cNormal.xy = cNormal1;
cNormal.z = sqrt ( 1.0-dot ( cNormal1 , cNormal1 ) );
return cNormal;
}
