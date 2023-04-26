
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
return ( incolor*i_debugparams[3].x+clr_chromaticity*i_debugparams[3].y+clr_decal*i_debugparams[3].z+clr_detail*i_debugparams[3].w+clr_diffuse*i_debugparams[4].x+clr_eccentricity*i_debugparams[4].y+clr_environment*i_debugparams[4].z+clr_luminocity*i_debugparams[4].w+clr_overlay*i_debugparams[5].x+clr_normal*i_debugparams[5].y+clr_reflectivity*i_debugparams[5].z+clr_specular*i_debugparams[5].w );


}

half4 ChooseDebugLighting ( half4 inLighting , half3 light_diffuse , half3 light_lightmap , half3 light_spec , half3 light_specsheen , half3 light_specref , half3 light_tangent , half3 all_lighting ) 
{
return half4 ( ( inLighting*i_debugparams[6].x+light_diffuse*i_debugparams[6].y+light_lightmap*i_debugparams[6].z+light_spec*i_debugparams[6].w+light_specsheen*i_debugparams[7].x+light_specref*i_debugparams[7].y+light_tangent*i_debugparams[7].z+all_lighting*i_debugparams[7].w ), 1.0 );


}
half3 ConvertRGBFromXYZ ( half3 inXyz ) 
{
return ( ( inXyz+1 )*0.5 );
}
half4 ChooseBNT ( half4 inColor , half3 binormal , half3 normal , half3 tangent ) 
{
return half4 ( ( inColor.rgb*i_debugparams[8].x+ConvertRGBFromXYZ ( binormal )*i_debugparams[8].z+ConvertRGBFromXYZ ( normal )*i_debugparams[8].w+ConvertRGBFromXYZ ( tangent )*i_debugparams[8].y ), inColor.a );


}
