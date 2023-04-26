
half4 GetDebugReflectClr ( samplerCUBE env_sampler , half3 normal , half3 viewdir ) 
{
half3 reflectVec = -reflect ( viewdir , normal );
half3 reflectClr = texCUBE ( env_sampler , reflectVec );
return half4 ( reflectClr, 1.0 );
reflectVec = abs ( reflectVec );

half maxComp = max ( max ( reflectVec.x , reflectVec.y ) , reflectVec.z );
reflectVec.xyz /= maxComp;
reflectClr *= saturate ( pow ( reflectVec , 100 )+half3 ( 0.5, 0.5, 0.5 ) );
return half4 ( reflectClr, 1.0f );


}
half4 MipMapValue ( float2 uv , sampler insampler ) 
{


float LOD;
asm {


return half4 ( LOD.xxx, 1 );


}

half4 ChooseDebugTexture ( half4 incolor , half4 clr_chromaticity , half4 clr_decal , half4 clr_detail , half4 clr_diffuse , half4 clr_eccentricity , half4 clr_environment , half4 clr_luminocity , half4 clr_overlay , half4 clr_normal , half4 clr_reflectivity , half4 clr_specular ) 

{
return ( incolor*1+clr_chromaticity*0+clr_decal*0+clr_detail*0+clr_diffuse*0+clr_eccentricity*0+clr_environment*0+clr_luminocity*0+clr_overlay*0+clr_normal*0+clr_reflectivity*0+clr_specular*0 );


}

half4 ChooseDebugLighting ( half4 inLighting , half3 light_diffuse , half3 light_lightmap , half3 light_spec , half3 light_specsheen , half3 light_specref , half3 light_tangent , half3 all_lighting ) 
{
return half4 ( ( inLighting*1+light_diffuse*0+light_lightmap*0+light_spec*0+light_specsheen*0+light_specref*0+light_tangent*0+all_lighting*0 ), 1.0 );


}
half3 ConvertRGBFromXYZ ( half3 inXyz ) 
{
return ( ( inXyz+1 )*0.5 );
}
half4 ChooseBNT ( half4 inColor , half3 binormal , half3 normal , half3 tangent ) 
{
return half4 ( ( inColor.rgb*1+ConvertRGBFromXYZ ( binormal )*0+ConvertRGBFromXYZ ( normal )*0+ConvertRGBFromXYZ ( tangent )*0 ), inColor.a );


}
